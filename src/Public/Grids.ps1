function Add-PuiGrid
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
        [int[]]
        $RowHeight,

        [Parameter()]
        [int[]]
        $ColumnWidth
    )

    $grid = [System.Windows.Controls.Grid]::new()
    $grid.Name = (Protect-PuiName -Name $Name)
    $grid.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Stretch
    $grid.VerticalAlignment = [System.Windows.VerticalAlignment]::Stretch

    foreach ($height in $RowHeight) {
        $def = [System.Windows.Controls.RowDefinition]::new()
        $def.Height = $height
        $grid.RowDefinitions.Add($def) | Out-Null
    }

    foreach ($width in $ColumnWidth) {
        $def = [System.Windows.Controls.ColumnDefinition]::new()
        $def.Width = [System.Windows.GridLength]::new($width)
        $grid.ColumnDefinitions.Add($def) | Out-Null
    }

    Add-PuiControl -Parent $Parent -Control $grid
    return $grid
}

function Set-PuiGridLocation
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [System.Windows.UIElement]
        $Element,

        [Parameter()]
        [int]
        $Row = 0,

        [Parameter()]
        [int]
        $Column = 0,

        [switch]
        $PassThru
    )

    [System.Windows.Controls.Grid]::SetColumn($Element, $Column)
    [System.Windows.Controls.Grid]::SetRow($Element, $Row)

    if ($PassThru) {
        return $Element
    }
}