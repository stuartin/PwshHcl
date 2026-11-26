class HclEdit {
    [string]$Binary
    [string]$Version
    [int]$LastExitCode

    HclEdit(
        [string]$Binary,
        [string]$Version
    ) {
        $this.Binary = $Binary
        $this.Version = $Version
    }

    # [string]
    [string] Execute([string]$Content, [string[]]$Arguments) {
        $allArgs = $Arguments

        # Capture stdout/stderr output cleanly into a variable
        $output = $Content | & $this.Binary @allArgs 2>&1
        $this.LastExitCode = $LASTEXITCODE

        if ($this.LastExitCode -ne 0) {
            throw "Command '$($this.Binary)' failed with exit code $($this.LastExitCode): $output"
        }

        return $output
    }

    # Optional overload with no arguments
    [object] Execute([string]$Content) {
        return $this.Execute($Content, @())
    }
}
