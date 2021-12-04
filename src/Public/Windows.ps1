function New-PuiWindow
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]
        $Title,

        [Parameter(Mandatory=$true)]
        [scriptblock]
        $Content,

        [Parameter()]
        [int]
        $Height = 0,

        [Parameter()]
        [int]
        $Width = 0,

        [Parameter()]
        [System.Windows.WindowStartupLocation]
        $StartupLocation = 'CenterScreen',

        [Parameter()]
        [System.Windows.ResizeMode]
        $ResizeMode = 'CanResize',

        [Parameter()]
        [System.Windows.Thickness]
        $Padding
    )

    try {
        $script:PuiContext = New-PuiContext
        New-PuiRunspaceState

        $window = [System.Windows.Window]::new()
        $window.Title = $Title
        $window.Content = [System.Windows.Controls.Grid]::new()
        $window.Padding = ($Padding | Protect-PuiThickness)
        $window.WindowStartupLocation = $StartupLocation
        $window.ResizeMode = $ResizeMode
        Set-PuiDimensions -Control $window -Width $Width -Height $Height

        $PuiContext.Window = $window

        Invoke-PuiScriptBlock -ScriptBlock $Content -NoNewClosure
        New-PuiRunspacePools
        Open-PuiRunspacePools

        return $window
    }
    catch {
        throw $_
    }
}

function Show-PuiWindow
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.Windows.Window]
        $Window
    )

    try {
        $Window.add_Closed({
            Close-PuiRunspaces
        })

        $Window.ShowDialog() | Out-Null
    }
    catch {
        throw $_
    }
}

function Import-PuiWindow
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Path,

        [Parameter()]
        [scriptblock]
        $Content
    )

    try {
        $script:PuiContext = New-PuiContext
        New-PuiRunspaceState

        $xaml = Get-Content $Path -Raw
        $xaml = ((($xaml -ireplace 'mc:Ignorable="d"', '') -ireplace "x:N", 'N') -ireplace '^<Win[\w]*', '<Window')
        $xaml = ($xaml -ireplace "\{null\}", '{x:Null}')

        $xaml = [xml]$xaml
        $reader = [System.Xml.XmlNodeReader]::new($xaml)
        $window = [System.Windows.Markup.XamlReader]::Load($reader)
        $PuiContext.Window = $window

        foreach ($control in $window.Content) {
            if ($null -eq $control) {
                continue
            }

            $control | Register-PuiControl
            $control.Children | Register-PuiWindowControls
        }

        if ($null -ne $Content) {
            Invoke-PuiScriptBlock -ScriptBlock $Content -NoNewClosure
        }

        New-PuiRunspacePools
        Open-PuiRunspacePools

        return $window
    }
    catch {
        $msg = $_.Exception.Message

        $exp = $_.Exception
        while ($null -ne $exp.InnerException) {
            $msg += "$([Environment]::NewLine)$($exp.InnerException.Message)"
            $exp = $exp.InnerException
        }

        throw ([System.Exception]::new($msg))
    }
}