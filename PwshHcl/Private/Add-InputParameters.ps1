function Add-InputParameters {
    <#
    .SYNOPSIS
        Used to dynamically inject -InputObject and -Path Parameters into other functions
    .DESCRIPTION
        Used to dynamically inject -InputObject and -Path Parameters into other functions
    #>
    [OutputType([System.Management.Automation.RuntimeDefinedParameterDictionary])]
    [CmdletBinding()]

    # 0. Define our Parameter Dictionary
    $parameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

    # 1. Define the Parameter Attributes
    # -InputObject
    $inputObjParameterAttrs = [System.Management.Automation.ParameterAttribute]@{
        Mandatory         = $true
        ValueFromPipeline = $true
        ParameterSetName  = 'StringInput'
    }

    # -Path
    $pathParameterAttrs = [System.Management.Automation.ParameterAttribute]@{
        Mandatory                   = $true
        ValueFromPipelineByPropertyName = $true
        ParameterSetName            = 'FileInput'
    }

    # 2. Create the Parameter Collection and add the Parameter
    # -InputObject
    $inputObjCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
    $inputObjCollection.Add($inputObjParameterAttrs)

    # -Path
    $pathCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
    $pathCollection.Add($pathParameterAttrs)
    $pathCollection.Add([System.Management.Automation.AliasAttribute]::new('FullName'))
    $pathCollection.Add([System.Management.Automation.ValidateScriptAttribute]::new({ Test-Path -Path $_ -PathType Leaf }))

    # 3. Create the Parameter and add it to the Dictionary
    # -InputObject
    $inputObjParameter = [System.Management.Automation.RuntimeDefinedParameter]::new('InputObject', [string], $inputObjCollection)
    $parameterDictionary.Add('InputObject', $inputObjParameter)

    # -Path
    $pathParameter = [System.Management.Automation.RuntimeDefinedParameter]::new('Path', [string], $pathCollection)
    $parameterDictionary.Add('Path', $pathParameter)

    return $parameterDictionary
}
