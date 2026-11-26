BeforeDiscovery {

  $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
  $outputDir = Join-Path -Path $env:BHProjectPath -ChildPath 'Output'
  $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
  $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
  $outputModVerManifest = Join-Path -Path $outputModVerDir -ChildPath "$($env:BHProjectName).psd1"

  # Get module commands
  # Remove all versions of the module from the session. Pester can't handle multiple versions.
  Get-Module $env:BHProjectName | Remove-Module -Force -ErrorAction Ignore
  Import-Module -Name $outputModVerManifest -Verbose:$false -ErrorAction Stop
}

Describe Get-HclEdit {
    Context 'When calling the function' {
        BeforeAll {
            $result = Get-HclEdit
        }

        It 'Should return a single object' {
            $result | Should -HaveCount 1
        }

        It 'Should return Binary and Version' {
            $result.PSObject.Properties.Name | Should -Contain 'Binary'
            $result.PSObject.Properties.Name | Should -Contain 'Version'
        }
    }
}

