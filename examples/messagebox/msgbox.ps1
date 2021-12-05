$path = Split-Path -Parent -Path  (Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path))
Import-Module "$($path)/src/PowerUI.psd1" -Force -ErrorAction Stop

$window = Import-PuiWindow -Path './msgbox.xaml' -Content {
    # bind event to load message box
    Get-PuiControl -Type Button -Name ShowMessageBox |
        Register-PuiEvent -Type Click -ScriptBlock {
            $result = Show-PuiMessageBox -Body 'Click any button' -Title 'My Title' -Button YesNoCancel
            Update-PuiTextboxValue -Name TextBox1 -Value $result
        }
}

$window | Show-PuiWindow