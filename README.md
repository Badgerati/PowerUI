# PowerUI

> This module is experimental, so expect bugs and feel free to raise them :)

PowerUI is a PowerShell framework for WPF and XAML. There is support for importing XAML, as well as support for building UIs purely with PowerShell - no XAML required!

When using XAML, nearly everything is supported. However, if you want to play with creating a UI purely with PowerShell, only a very basic handful of elements are supported:

* Textbox
* Button
* Grid
* Label
* plus any events

## Import

If you have an existing XAML file, designed in Visual Studio, you can import it into PowerUI via `Import-PuiWindow`. The XAML needs to have no events (like Click, KeyUp, etc) present, and if needed these can be bound within your PowerUI script.

For example, assume you have the following XAML (saved as "numpad.xaml"):

```xml
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Example"
    Height="283" Width="782"
    WindowStartupLocation="CenterScreen">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition/>
            <RowDefinition/>
            <RowDefinition/>
            <RowDefinition/>
            <RowDefinition/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>

        <TextBox Grid.ColumnSpan="3" IsReadOnly="True" x:Name="Result" />

        <Button x:Name="Btn1" Grid.Row="1" Grid.Column="0">1</Button>
        <Button x:Name="Btn2" Grid.Row="1" Grid.Column="1">2</Button>
        <Button x:Name="Btn3" Grid.Row="1" Grid.Column="2">3</Button>
        <Button x:Name="Btn4" Grid.Row="2" Grid.Column="0">4</Button>
        <Button x:Name="Btn5" Grid.Row="2" Grid.Column="1">5</Button>
        <Button x:Name="Btn6" Grid.Row="2" Grid.Column="2">6</Button>
        <Button x:Name="Btn7" Grid.Row="3" Grid.Column="0">7</Button>
        <Button x:Name="Btn8" Grid.Row="3" Grid.Column="1">8</Button>
        <Button x:Name="Btn9" Grid.Row="3" Grid.Column="2">9</Button>
        <Button x:Name="BtnStar" Grid.Row="4" Grid.Column="0">*</Button>
        <Button x:Name="Btn0" Grid.Row="4" Grid.Column="1">0</Button>
        <Button x:Name="BtnHash" Grid.Row="4" Grid.Column="2">#</Button>
    </Grid>
</Window>
```

This renders a textbox and a 3x4 grid of buttons with number. We now want the buttons to be clickable, and when clicked update the textbox:

```powershell
Import-Module PowerUI

# import the xaml
$window = Import-PuiWindow -Path './numpad.xaml' -Content {

    # select all buttons via regex, and register a click event to each
    Get-PuiControl -Type Button -Name 'Btn.+' -Pattern | Register-PuiEvent -Type Click -ScriptBlock {
        param($evt, $self)

        # get the current value of the textbox
        $value = Get-PuiTextboxValue -Name Result

        # get the value of the button pressed
        $pressed = Get-PuiButtonValue -Name $self.Name

        # update the textbox
        Update-PuiTextboxValue -Name Result -Value "$($value)$($pressed)"
    }
}

# show the window
$window | Show-PuiWindow
```

Which looks as follows:

![numpad](/images/numpad.png)

Besides events, you can also add further controls to the window (see below).

## PowerShell

PowerUI also lets you create UIs without XAML. The following example displays a UI with a textbox to type some powershell into, and pressing Enter - or clicking the button - will run the query and output the results in the bottom textbox:

```powershell
Import-Module PowerUI

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
    $grid2 | Add-PuiLabel -Content 'Query:' -Margin '10,15,0,0' | Set-PuiGridLocation -Column 0
    $textbox = ($grid2 | Add-PuiTextbox -Name 'Query' -Height 23 | Set-PuiGridLocation -Column 1 -PassThru)

    # add button to 3rd column
    $button = ($grid2 |
        Add-PuiButton -Name 'Query' -Content 'Query' -Margin '12,0,12,0' -Height 23 |
        Set-PuiGridLocation -Column 2 -PassThru)

    # register click on button to run query and output results
    $button | Register-PuiEvent -Type Click -ScriptBlock {
        $query = Get-PuiTextboxValue -Name 'Query'

        # check if query is empty, if not then run and show results
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
```

Which looks as follows:

![run_query](/images/run_query.png)

## Functions

Below is a list of all the current functions available:

* Add-PuiButton
* Add-PuiGrid
* Add-PuiLabel
* Add-PuiTextbox
* Get-PuiButtonValue
* Get-PuiControl
* Get-PuiControlProperty
* Get-PuiTextboxValue
* Import-PuiWindow
* Invoke-PuiEvent
* New-PuiWindow
* Register-PuiEvent
* Set-PuiGridLocation
* Show-PuiWindow
* Update-PuiButtonValue
* Update-PuiControlProperty
* Update-PuiTextboxValue

## To Do

Still yet to do (pretty much all in terms of building a UI with just PowerShell):

* CheckBox
* ComboBox / ComboBoxItem
* Image
* ListBox / ListBoxItem
* LisView
* Panel
* PasswordBox
* Messagebox
* Progressbar
* RadioButton
* RichTextbox
* Tooltip?
* Taskbar?
* WebBrowser