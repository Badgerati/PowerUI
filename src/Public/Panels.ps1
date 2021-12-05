function Add-PuiStackPanel
{
    [CmdletBinding(DefaultParameterSetName='RowCount_ColumnCount')]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [System.Windows.Controls.Panel]
        $Parent,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [System.Windows.Thickness]
        $Margin,

        [Parameter()]
        [System.Windows.Thickness]
        $Padding
    )

    # create stack panel
    $panel = [System.Windows.Controls.StackPanel]::new()
    $panel.Name = (Protect-PuiName -Name $Name)
    $panel.Margin = ($Margin | Protect-PuiThickness)
    $panel.Padding = ($Padding | Protect-PuiThickness)

    # add panel
    Add-PuiControl -Parent $Parent -Control $panel
    return $panel
}