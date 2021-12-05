function Add-PuiLabel
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [System.Windows.Controls.Panel]
        $Parent,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Value,

        [Parameter()]
        [int]
        $FontSize = 12,

        [Parameter()]
        [System.Windows.UIElement]
        $Target,

        [Parameter()]
        [System.Windows.Thickness]
        $Margin,

        [Parameter()]
        [System.Windows.Thickness]
        $Padding
    )

    $label = [System.Windows.Controls.Label]::new()
    $label.Name = (Protect-PuiName -Name $Name)
    $label.Content = $Value
    $label.FontSize = $FontSize
    $label.Margin = ($Margin | Protect-PuiThickness)
    $label.Padding = ($Padding | Protect-PuiThickness)

    if ($null -ne $Target) {
        $label | Set-PuiLabelTarget -Target $Target
    }

    Add-PuiControl -Parent $Parent -Control $label
    return $label
}

function Set-PuiLabelTarget
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.Windows.Controls.Label]
        $Label,

        [Parameter()]
        [System.Windows.UIElement]
        $Target,

        [switch]
        $PassThru
    )

    # bind the target
    $Label.Target = $Target

    # bind auto-left click
    $Label | Register-PuiEvent -Type MouseUp -ScriptBlock {
        param($evt, $self)
        if ($evt.ChangedButton -ieq 'left') {
            Get-PuiControlProperty -Name $self.Name -Type $self.Type -Property Target | Set-PuiControlFocus
        }
    }

    # return?
    if ($PassThru) {
        return $Label
    }
}

function Add-PuiTextBlock
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [System.Windows.Controls.Panel]
        $Parent,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Value,

        [Parameter()]
        [int]
        $FontSize = 12,

        [Parameter()]
        [System.Windows.Thickness]
        $Margin,

        [Parameter()]
        [System.Windows.Thickness]
        $Padding
    )

    $textblock = [System.Windows.Controls.TextBlock]::new()
    $textblock.Name = (Protect-PuiName -Name $Name)
    $textblock.Content = $Value
    $textblock.FontSize = $FontSize
    $textblock.Margin = ($Margin | Protect-PuiThickness)
    $textblock.Padding = ($Padding | Protect-PuiThickness)

    Add-PuiControl -Parent $Parent -Control $textblock
    return $textblock
}