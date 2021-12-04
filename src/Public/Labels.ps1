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
        $Content,

        [Parameter()]
        [System.Windows.Thickness]
        $Margin,

        [Parameter()]
        [System.Windows.Thickness]
        $Padding
    )

    $label = [System.Windows.Controls.Label]::new()
    $label.Name = (Protect-PuiName -Name $Name)
    $label.Content = $Content
    $label.Margin = ($Margin | Protect-PuiThickness)
    $label.Padding = ($Padding | Protect-PuiThickness)

    Add-PuiControl -Parent $Parent -Control $label
    return $label
}