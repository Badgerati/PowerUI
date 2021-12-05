function Show-PuiMessageBox
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Body,

        [Parameter()]
        [string]
        $Title = 'Dialog',

        [Parameter()]
        [System.Windows.MessageBoxButton]
        $Button = [System.Windows.MessageBoxButton]::OK,

        [Parameter()]
        [System.Windows.MessageBoxImage]
        $Icon = [System.Windows.MessageBoxImage]::None,

        [Parameter()]
        [System.Windows.MessageBoxResult]
        $DefaultResult = [System.Windows.MessageBoxResult]::None,

        [Parameter()]
        [System.Windows.MessageBoxOptions]
        $Options = [System.Windows.MessageBoxOptions]::None
    )

    if ($PuiContext.Window.Dispatcher.CheckAccess()) {
        $script:result = [System.Windows.MessageBox]::Show($PuiContext.Window, $Body, $Title, $Button, $Icon, $DefaultResult, $Options)
    }
    else {
        $PuiContext.Window.Dispatcher.Invoke([System.Action]{
            $script:result = [System.Windows.MessageBox]::Show($PuiContext.Window, $Body, $Title, $Button, $Icon, $DefaultResult, $Options)
        })
    }

    return $result
}