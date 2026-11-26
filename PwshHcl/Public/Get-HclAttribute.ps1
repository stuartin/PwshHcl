function Get-HclAttribute {
    <#
    .SYNOPSIS
        Returns the value of a specific attribute from the HCL content
    .DESCRIPTION
        Returns the value of a specific attribute from the HCL content
    .EXAMPLE
        @'
        resource "azurerm_resource_group" "rg" {
          name     = "cc-dv-example-rg"
          location = "canadacentral"
        }
        '@ | Get-HclAttribute -Address "resource.azurerm_resource_group.rg.name"

        cc-dv-example-rg
    #>
    [OutputType([string])]
    [CmdletBinding(DefaultParameterSetName = 'StringInput')]
    param (
        # The terraform state address
        [Parameter(Mandatory)]
        [string]$Address,

        # Whether to trim the quotes from the returned value
        [Parameter()]
        [bool]$TrimQuotes = $true
    )

    dynamicparam {
        Add-InputParameters
    }

    process {
        $content = Resolve-InputParameters -BoundParameters $PSBoundParameters -ParameterSetName $PSCmdlet.ParameterSetName
        $result = $script:hclEdit.Execute($content, @("attribute", "get", $Address))

        if ($TrimQuotes) {
            $result = $result.Trim('"')
        }
        $result
    }
}
