function New-PuiContext
{
    param()

    $ctx = [Hashtable]::Synchronized(@{})

    # module path
    $ctx.ModulePath = Get-PuiModulePath

    # controls
    $ctx.Window = $null
    $ctx.Controls = @{}

    # session state
    $ctx.Lockable = [hashtable]::Synchronized(@{})

    # runspace pools
    $ctx.RunspacePools = @{
        Background  = $null
        LongRunning = $null
    }

    # setup runspaces
    $ctx.RunspaceState = $null
    $ctx.Runspaces = @()

    # return the new context
    return $ctx
}

function New-PuiRunspaceState
{
    # create the state, and add the PowerUI module
    $state = [initialsessionstate]::CreateDefault()
    $state.ImportPSModule($PuiContext.ModulePath)

    # load the vars into the share state
    $session = New-PuiStateContext -Context $PuiContext

    $variables = @(
        (New-Object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'PuiContext', $session, $null),
        (New-Object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'Console', $Host, $null),
        (New-Object System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'POWERUI_SCOPE_RUNSPACE', $true, $null)
    )

    foreach ($var in $variables) {
        $state.Variables.Add($var)
    }

    $PuiContext.RunspaceState = $state
}

function New-PuiStateContext
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        $Context
    )

    return [Hashtable]::Synchronized(@{
        Window = $Context.Window
        Controls = $Context.Controls
        RunspacePools = $Context.RunspacePools
        Lockable = $Context.Lockable
    })
}

function New-PuiRunspacePools
{
    # background runspace - for controls, etc
    $PuiContext.RunspacePools.Background = [runspacefactory]::CreateRunspacePool(1, 3, $PuiContext.RunspaceState, $Host)
    $PuiContext.RunspacePools.Background.ApartmentState = 'STA'

    # long running runspace - for long running processes/queries
    $PuiContext.RunspacePools.LongRunning = [runspacefactory]::CreateRunspacePool(1, 3, $PuiContext.RunspaceState, $Host)
    $PuiContext.RunspacePools.LongRunning.ApartmentState = 'STA'
}

function Open-PuiRunspacePools
{
    foreach ($key in $PuiContext.RunspacePools.Keys) {
        if ($null -ne $PuiContext.RunspacePools[$key]) {
            $PuiContext.RunspacePools[$key].Open()
        }
    }
}

function Close-PuiRunspaces
{
    if ($null -ne $PuiContext.RunspacePools) {
        $PuiContext.RunspacePools.Values | Where-Object { $null -ne $_ -and !$_.IsDisposed } | ForEach-Object {
            $_.Close()
            $_.Dispose()
        }
    }
}