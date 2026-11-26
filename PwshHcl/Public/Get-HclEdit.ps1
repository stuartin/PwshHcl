Function Get-HclEdit {
    <#
    .SYNOPSIS
        Returns the binary location and version for hcledit
    .DESCRIPTION
        Returns the binary location and version for hcledit
    .EXAMPLE
        Get-HclEdit

        Binary                                                                              Version
        ------                                                                              -------
        C:\Users\pwshhcl\modules\PwshHcl\0.0.1\bin\hcledit_0.2.19_windows_amd64\hcledit.exe 0.2.19
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]

    $hclEdit = $script:hclEdit

    [PSCustomObject]@{
        Binary = $hclEdit.Binary
        Version = $hclEdit.Version
    }
}
