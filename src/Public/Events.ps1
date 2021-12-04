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

    if (!(Test-PuiControlEventSupported -Control $Control -Type $Type)) {
        $ctlType = $Control | Get-PuiControlType
        throw "$($ctlType) control '$($Control.Name)' does not support '$($Type)' event"
    }

    $PuiContext.Window.Dispatcher.Invoke([System.Action]{
        $ctlType = $Control | Get-PuiControlType
        Invoke-Expression -Command "`$Control.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.$($ctlType)]::$($Type)Event))"
    })
}