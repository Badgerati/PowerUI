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
        [int]
        $RowCount = 0,

        [Parameter()]
        [int[]]
        $ColumnWidth,

        [Parameter()]
        [int]
        $ColumnCount = 0
    )

    # create grid
    $grid = [System.Windows.Controls.Grid]::new()
    $grid.Name = (Protect-PuiName -Name $Name)
    $grid.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Stretch
    $grid.VerticalAlignment = [System.Windows.VerticalAlignment]::Stretch

    # rows
    if ($RowCount -gt 0) {
        $RowHeight = @(1..$RowCount | ForEach-Object { -1 })
    }

    foreach ($height in $RowHeight) {
        $def = [System.Windows.Controls.RowDefinition]::new()

        if ($height -ge 0) {
            $def.Height = $height
        }

        $grid.RowDefinitions.Add($def) | Out-Null
    }

    # columns
    if ($ColumnCount -gt 0) {
        $ColumnWidth = @(1..$ColumnCount | ForEach-Object { -1 })
    }

    foreach ($width in $ColumnWidth) {
        $def = [System.Windows.Controls.ColumnDefinition]::new()

        if ($width -ge 0) {
            $def.Width = [System.Windows.GridLength]::new($width)
        }

        $grid.ColumnDefinitions.Add($def) | Out-Null
    }

    # add grid
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
        $RowSpan = 1,

        [Parameter()]
        [int]
        $Column = 0,

        [Parameter()]
        [int]
        $ColumnSpan = 1,

        [switch]
        $PassThru
    )

    # col
    [System.Windows.Controls.Grid]::SetColumn($Element, $Column)
    [System.Windows.Controls.Grid]::SetColumnSpan($Element, $ColumnSpan)

    #row
    [System.Windows.Controls.Grid]::SetRow($Element, $Row)
    [System.Windows.Controls.Grid]::SetRowSpan($Element, $RowSpan)

    #return?
    if ($PassThru) {
        return $Element
    }
}