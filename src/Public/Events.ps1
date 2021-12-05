function Register-PuiEvent
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Control,

        [Parameter(Mandatory=$true)]
        [ValidateSet('Click', 'KeyDown', 'KeyUp', 'LostFocus', 'GotFocus', 'MouseDown', 'MouseUp', 'MouseEnter', 'MouseLeave', 'MouseMove', 'MouseWheel')]
        [string]
        $Type,

        [Parameter(Mandatory=$true)]
        [scriptblock]
        $ScriptBlock
    )

    begin {
        $controls = @()
    }

    process {
        if ($null -ne $Control) {
            $controls += $Control
        }
    }

    end {
        foreach ($control in $controls) {
            $ctlType = $control | Get-PuiControlType

            if (!(Test-PuiControlEventSupported -Control $control -Type $Type)) {
                throw "$($ctlType) control '$($control.Name)' does not support '$($Type)' event"
            }

            if (!$PuiContext.Controls[$ctlType][$control.Name].Events[$Type]) {
                $PuiContext.Controls[$ctlType][$control.Name].Events[$Type] = @()
            }

            $PuiContext.Controls[$ctlType][$control.Name].Events[$Type] += $ScriptBlock

            Invoke-Expression -Command "`$control.add_$($Type)((Get-PuiEventHandler))"
        }
    }
}

function Invoke-PuiEvent
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Control,

        [Parameter(Mandatory=$true)]
        [ValidateSet('Click', 'KeyDown', 'KeyUp', 'LostFocus', 'GotFocus', 'MouseDown', 'MouseUp', 'MouseEnter', 'MouseLeave', 'MouseMove', 'MouseWheel')]
        [string]
        $Type
    )

    $ctlType = $Control | Get-PuiControlType

    if (!(Test-PuiControlEventSupported -Control $Control -Type $Type)) {
        throw "$($ctlType) control '$($Control.Name)' does not support '$($Type)' event"
    }

    $cmd = "`$Control.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.$($ctlType)]::$($Type)Event))"

    if ($PuiContext.Window.Dispatcher.CheckAccess()) {
        Invoke-Expression -Command $cmd | Out-Null
    }
    else {
        $PuiContext.Window.Dispatcher.Invoke([System.Action]{
            Invoke-Expression -Command $cmd | Out-Null
        })
    }
}