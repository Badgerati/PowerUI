function Add-PuiImage
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
        $Source,

        [Parameter()]
        [ValidateRange(0.0, 1.0)]
        [double]
        $Opacity = 1.0,

        [Parameter()]
        [int]
        $Height = 0,

        [Parameter()]
        [int]
        $Width = 0,

        [Parameter()]
        [System.Windows.Thickness]
        $Margin
    )

    $image = [System.Windows.Controls.Image]::new()
    $image.Name = (Protect-PuiName -Name $Name)
    $image.Source = $Source
    $image.Opacity = $Opacity
    $image.Margin = ($Margin | Protect-PuiThickness)

    if ($Width -gt 0) {
        $image.Width = $Width
    }

    if ($Height -gt 0) {
        $image.Height = $Height
    }

    Add-PuiControl -Parent $Parent -Control $image
    return $image
}