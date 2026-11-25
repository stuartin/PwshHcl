function Get-HclEditBinaryPath {
    [CmdletBinding()]

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
    $binPath = Join-Path -Path $PSScriptRoot -ChildPath (Join-Path -Path 'bin' -ChildPath "hcledit_0.2.19_$($os)_$($arch)/$exeName")

    if (-not (Test-Path -Path $binPath -PathType Leaf)) {
        throw "Bundled hcledit binary not found at: $binPath"
    }

    if ($os -ne 'windows') {
        & chmod +x $binPath 2>$null
    }

    return $binPath
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
$script:hclEdit = Get-HclEditBinaryPath
