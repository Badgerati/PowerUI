function Get-PuiModulePath
{
    $importedModule = @(Get-Module -Name PowerUI)
    if (($importedModule | Measure-Object).Count -eq 1) {
        return (@($importedModule)[0]).Path
    }

    return (@($importedModule | Sort-Object -Property Version)[-1]).Path
}

function Invoke-PuiScriptBlock
{
    [CmdletBinding()]
    [OutputType([object])]
    param (
        [Parameter(Mandatory=$true)]
        [scriptblock]
        $ScriptBlock,

        [Parameter()]
        $Arguments = $null,

        [switch]
        $Scoped,

        [switch]
        $Return,

        [switch]
        $Splat,

        [switch]
        $NoNewClosure
    )

    if (!$NoNewClosure) {
        $ScriptBlock = ($ScriptBlock).GetNewClosure()
    }

    if ($Scoped) {
        if ($Splat) {
            $result = (& $ScriptBlock @Arguments)
        }
        else {
            $result = (& $ScriptBlock $Arguments)
        }
    }
    else {
        if ($Splat) {
            $result = (. $ScriptBlock @Arguments)
        }
        else {
            $result = (. $ScriptBlock $Arguments)
        }
    }

    if ($Return) {
        return $result
    }
}

function Set-PuiDimensions
{
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Controls.Control]
        $Control,

        [Parameter()]
        [int]
        $Height = 0,

        [Parameter()]
        [int]
        $Width = 0
    )

    if ($Width -gt 0) {
        $Control.Width = $Width
    }

    if ($Height -gt 0) {
        $Control.Height = $Height
    }
}

function Protect-PuiThickness
{
    param(
        [Parameter(ValueFromPipeline=$true)]
        [System.Object]
        $Value
    )

    if ($null -eq $Value) {
        return ([System.Windows.Thickness]'0,0,0,0')
    }

    return $Value
}

function Get-PuiRandomName
{
    param(
        [Parameter()]
        [int]
        $Length = 5
    )

    $value = (65..90) | Get-Random -Count $Length | ForEach-Object { [char]$_ }
    return [String]::Concat($value)
}

function Protect-PuiName
{
    param(
        [Parameter()]
        [string]
        $Name
    )

    if (![string]::IsNullOrEmpty($Name)) {
        return $Name
    }

    return (Get-PuiRandomName)
}