function Resolve-InputParameters {
    <#
    .SYNOPSIS
        Used to resolve inputs to a string from Add-InputParameters
    .DESCRIPTION
        Used to resolve inputs to a string from Add-InputParameters
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Collections.Hashtable]$BoundParameters,

        [Parameter(Mandatory)]
        [string]$ParameterSetName
    )

    if ($ParameterSetName -eq 'FileInput') {
        Get-Content -Path $BoundParameters['Path'] -Raw
    }
    else {
        $BoundParameters['InputObject']
    }
}
