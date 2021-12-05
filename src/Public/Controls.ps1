function Get-PuiControlProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Type,

        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$true)]
        [string[]]
        $Property
    )

    if (($null -eq $Property) -or ($Property.Length -eq 0)) {
        $null
    }

    if ($PuiContext.Window.Dispatcher.CheckAccess()) {
        if ($Property.Length -eq 1) {
            $script:result = $PuiContext.Controls[$Type][$Name].Control | Select-Object -ExpandProperty $Property[0]
        }
        else {
            $script:result = $PuiContext.Controls[$Type][$Name].Control | Select-Object -Property $Property
        }
    }
    else {
        $PuiContext.Window.Dispatcher.Invoke([System.Action]{
            if ($Property.Length -eq 1) {
                $script:result = $PuiContext.Controls[$Type][$Name].Control | Select-Object -ExpandProperty $Property[0]
            }
            else {
                $script:result = $PuiContext.Controls[$Type][$Name].Control | Select-Object -Property $Property
            }
        })
    }

    return $result
}

function Get-PuiControl
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Type,

        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [switch]
        $Pattern
    )

    if (!$Pattern) {
        return $PuiContext.Controls[$Type][$Name].Control
    }

    foreach ($t in $PuiContext.Controls.Keys) {
        if ($t -inotmatch $Type) {
            continue
        }

        foreach ($n in $PuiContext.Controls[$t].Keys) {
            if ($n -inotmatch $Name) {
                continue
            }

            $PuiContext.Controls[$t][$n].Control
        }
    }
}

function Set-PuiControlFocus
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.Windows.UIElement]
        $Control
    )

    if ($PuiContext.Window.Dispatcher.CheckAccess()) {
        $Control.Focus()
    }
    else {
        $PuiContext.Window.Dispatcher.Invoke([System.Action]{
            $Control.Focus()
        })
    }
}

function Update-PuiControlProperty
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Type,

        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$true)]
        [string]
        $Property,

        [Parameter(Mandatory=$true)]
        [string]
        $Value
    )

    if ($PuiContext.Window.Dispatcher.CheckAccess()) {
        $PuiContext.Controls[$Type][$Name].Control.$Property = $Value
    }
    else {
        $PuiContext.Window.Dispatcher.Invoke([System.Action]{
            $PuiContext.Controls[$Type][$Name].Control.$Property = $Value
        })
    }
}