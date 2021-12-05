$path = Split-Path -Parent -Path  (Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path))
Import-Module "$($path)/src/PowerUI.psd1" -Force -ErrorAction Stop

$window = New-PuiWindow -Title 'Run PowerShell' -Height 400 -Width 430 -Content {
    # add grid with 2 rows
    $grid1 = Add-PuiGrid -RowHeight 50, 300

    # add results textbox to 2nd row
    $grid1 |
        Add-PuiTextbox -Name 'Results' -Margin '0,60,0,0' -Height 225 -Width 373 -IsReadOnly |
        Set-PuiGridLocation -Row 1 -Column 1

    # add grid with 3 columns to 1st row
    $grid2 = ($grid1 | Add-PuiGrid -RowHeight 50 -ColumnWidth 133,133,133)

    # add low/textbox to 1st/2nd columns
    $label = ($grid2 | Add-PuiLabel -Value 'Query:' -Margin '10,15,0,0' | Set-PuiGridLocation -Column 0 -PassThru)
    $textbox = ($grid2 | Add-PuiTextbox -Name 'Query' -Height 23 | Set-PuiGridLocation -Column 1 -PassThru)
    $label | Set-PuiLabelTarget -Target $textbox

    # add button to 3rd column
    $button = ($grid2 |
        Add-PuiButton -Name 'Query' -Value 'Query' -Margin '12,0,12,0' -Height 23 |
        Set-PuiGridLocation -Column 2 -PassThru)

    # register click on button to run query and output results
    $button | Register-PuiEvent -Type Click -ScriptBlock {
        $result = Show-PuiMessageBox -Body 'Are you sure you want to run the query?' -Button YesNo
        if ($result -ieq 'no') {
            return
        }

        $query = Get-PuiTextboxValue -Name 'Query'

        if (![string]::IsNullOrWhiteSpace($query)) {
            $output = (Invoke-Expression -Command $query) | Out-String
            Update-PuiTextboxValue -Name 'Results' -Value $output
        }
        else {
            Update-PuiTextboxValue -Name 'Results' -Value 'No query supplied'
        }
    }

    # register enter key on textbox, to click button
    $textbox | Register-PuiEvent -Type KeyUp -ScriptBlock {
        param($evt)
        if ($evt.Key -ine 'return') {
            return
        }

        # get the button, and click it
        Get-PuiControl -Type Button -Name Query | Invoke-PuiEvent -Type Click
    }

}

# show window
$window | Show-PuiWindow