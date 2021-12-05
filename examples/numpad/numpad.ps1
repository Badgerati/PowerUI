$path = Split-Path -Parent -Path  (Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path))
Import-Module "$($path)/src/PowerUI.psd1" -Force -ErrorAction Stop

$window = Import-PuiWindow -Path './numpad.xaml' -Content {
    Get-PuiControl -Type Button -Name 'Btn.+' -Pattern | Register-PuiEvent -Type Click -ScriptBlock {
        param($evt, $self)

        $value = Get-PuiTextboxValue -Name Result
        $pressed = Get-PuiButtonValue -Name $self.Name

        Update-PuiTextboxValue -Name Result -Value "$($value)$($pressed)"
    }
}

$window | Show-PuiWindow