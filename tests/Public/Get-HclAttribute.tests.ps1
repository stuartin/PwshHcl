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

Describe Get-HclAttribute {
    Context 'When calling the function' {
        BeforeAll {
            $content = @(
                'resource "azurerm_resource_group" "rg" {',
                '    name     = "cc-dv-example-rg"',
                '    location = "canadacentral"',
                '}'
            ) -join "`n"
        }

        It 'Should work with InputObject' {
            $result = Get-HclAttribute -InputObject $content -Address "resource.azurerm_resource_group.rg.name"
            $result | Should -Be "cc-dv-example-rg"
        }

        It 'Should work with Path' {
            $testPath = "TestDrive:\main.tf"
            Set-Content -Path $testPath -Value $content

            $result = Get-HclAttribute -Path $testPath -Address "resource.azurerm_resource_group.rg.name"
            $result | Should -Be "cc-dv-example-rg"
        }

    }
}

