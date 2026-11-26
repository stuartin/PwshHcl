function Get-HclEditDetails {
    [CmdletBinding()]

    $version = "0.2.19"

    $os = if ($IsMacOS) {
        'darwin'
    } elseif ($IsLinux) {
        'linux'
    } elseif ($IsWindows -or ($PSVersionTable.PSVersion.Major -lt 6)) {
        'windows'
    } else {
        throw 'Unsupported OS.'
    }

    $arch = if ($os -ne 'windows') {
        switch ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture) {
            'X64'   { 'amd64' }
            default { throw "Unsupported architecture: $_" }
        }
    } else {
        switch ($env:PROCESSOR_ARCHITECTURE) {
            'AMD64' { 'amd64' }
            default { throw "Unsupported Windows architecture: $_" }
        }
    }

    $exeName = if ($os -eq 'windows') { 'hcledit.exe' } else { 'hcledit' }
    $binPath = Join-Path -Path $PSScriptRoot -ChildPath (Join-Path -Path 'bin' -ChildPath "hcledit_$($version)_$($os)_$($arch)/$exeName")

    if (-not (Test-Path -Path $binPath -PathType Leaf)) {
        throw "Bundled hcledit binary not found at: $binPath"
    }

    if ($os -ne 'windows') {
        & chmod +x $binPath 2>$null
    }

    return @{
        Binary = $binPath
        Version = $version
    }
}



# Dot source public/private functions
$classes = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Classes/*.ps1') -Recurse -ErrorAction Stop)
$public = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public/*.ps1')  -Recurse -ErrorAction Stop)
$private = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Private/*.ps1') -Recurse -ErrorAction Stop)
foreach ($import in @($classes + $public + $private)) {
    try {
        . $import.FullName
    } catch {
        throw "Unable to dot source [$($import.FullName)]"
    }
}

Export-ModuleMember -Function $public.Basename
$hclEditDetails = Get-HclEditDetails
$script:hclEdit = [HclEdit]::new($hclEditDetails.Binary, $hclEditDetails.Version)
