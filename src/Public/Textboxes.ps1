function Add-PuiTextbox
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
        $Text,

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
        $Padding,

        [switch]
        $IsReadOnly
    )

    $textbox = [System.Windows.Controls.TextBox]::new()
    $textbox.Name = $Name
    $textbox.Text = $Text
    $textbox.IsReadOnly = $IsReadOnly.IsPresent
    $textbox.Margin = ($Margin | Protect-PuiThickness)
    $textbox.Padding = ($Padding | Protect-PuiThickness)
    Set-PuiDimensions -Control $textbox -Width $Width -Height $Height

    Add-PuiControl -Parent $Parent -Control $textbox
    return $textbox
}

function Get-PuiTextboxValue
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Name
    )

    Get-PuiControlProperty -Type Textbox -Name $Name -Property Text
}

function Update-PuiTextboxValue
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

    Update-PuiControlProperty -Type Textbox -Name $Name -Property Text -Value $Value
}