@{
    PSDepend = @{
        Version = '0.3.8'
    }
    PSDependOptions = @{
        Target = 'CurrentUser'
    }
    'Pester' = @{
        Version = '6.2.0'
        Parameters = @{
            SkipPublisherCheck = $true
        }
        # Import = $false
    }
    'psake' = @{
        Version = '4.9.0'
    }
    'BuildHelpers' = @{
        Version = '2.0.16'
    }
    'PowerShellBuild' = @{
        Version = '0.6.1'
    }
    'PSScriptAnalyzer' = @{
        Version = '1.19.1'
    }
}
