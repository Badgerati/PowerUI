function Add-PuiButton
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [System.Windows.Controls.Panel]
        $Parent,

        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Content,

        [Parameter()]
        [int]
        $Height = 0,

        [Parameter()]
        [int]
        $Width = 0,

        [Parameter()]
        [System.Windows.Thickness]
        $Margin,

        [Parameter()]
        [System.Windows.Thickness]
        $Padding
    )

    $button = [System.Windows.Controls.Button]::new()
    $button.Name = $Name
    $button.Content = $Content
    $button.Margin = ($Margin | Protect-PuiThickness)
    $button.Padding = ($Padding | Protect-PuiThickness)
    Set-PuiDimensions -Control $button -Width $Width -Height $Height

    Add-PuiControl -Parent $Parent -Control $button
    return $button
}

function Get-PuiButtonValue
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Name
    )

    Get-PuiControlProperty -Type Button -Name $Name -Property Content
}

function Update-PuiButtonValue
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Value
    )

    Update-PuiControlProperty -Type Button -Name $Name -Property Content -Value $Value
}