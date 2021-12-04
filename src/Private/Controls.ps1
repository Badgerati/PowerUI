function Add-PuiControl
{
    param(
        [Parameter()]
        [System.Windows.Controls.Panel]
        $Parent,

        [Parameter(Mandatory=$true)]
        $Control
    )

    if ($null -ne $Parent) {
        $Parent.Children.Add($Control) | Out-Null
    }
    else {
        $PuiContext.Window.Content.Children.Add($Control) | Out-Null
    }

    $Control | Register-PuiControl
}

function Register-PuiControl
{
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Control
    )

    $ctlType = $Control | Get-PuiControlType

    if (!$PuiContext.Controls.ContainsKey($ctlType)) {
        $PuiContext.Controls[$ctlType] = @{}
    }

    $PuiContext.Controls[$ctlType][$Control.Name] = @{
        Control = $Control
        Events = @{}
    }
}

function Register-PuiWindowControls
{
    param(
        [Parameter(ValueFromPipeline=$true)]
        $Control
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
            if ($null -eq $control) {
                continue
            }

            $control | Register-PuiControl
            $control.Children | Register-PuiWindowControls
        }
    }
}

function Get-PuiControlType
{
    param(
        [Parameter(ValueFromPipeline=$true)]
        $Control
    )

    return $Control.GetType().Name
}