function Get-PuiEventHandler
{
    return {
        param($control, $evt)
        $ctlType = $control | Get-PuiControlType

        $events = $PuiContext.Controls[$ctlType][$control.Name].Events[$evt.RoutedEvent.Name]
        if (!$events) {
            return
        }

        $action = [powershell]::Create()

        $action.AddScript({
            param($control, $evt)
            try{
                foreach ($e in $PuiContext.Controls[$control.Type][$control.Name].Events[$evt.RoutedEvent.Name]) {
                    Invoke-PuiScriptBlock -ScriptBlock $e -Arguments $evt, $control -NoNewClosure -Splat
                }
            }
            catch {
                $_ | out-default
            }
        }, $true) | Out-Null

        $action.AddParameter('control', @{
            Name = $control.Name
            Type = $ctlType
        }) | Out-Null

        $action.AddParameter('evt', $evt) | Out-Null

        $action.RunspacePool = $PuiContext.RunspacePools.Background
        $action.BeginInvoke() | Out-Null
    }
}

function Test-PuiControlEventSupported
{
    param(
        [Parameter(Mandatory=$true)]
        $Control,

        [Parameter(Mandatory=$true)]
        [string]
        $Type
    )

    return (($Control | Get-Member -MemberType Event).Name -icontains $Type)
}