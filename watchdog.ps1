## watchdog.ps1

# PowerShell watchdog that detects when Antigravity UI is stuck on "Running command"
# and automatically runs fix.bat to clean up stray processes.

# Configuration
$processName = "Antigravity"            # Name of the Antigravity executable (without .exe)
$stuckTitle   = "Running command"        # Text that appears in the window title when stuck
$checkInterval = 5                        # Seconds between checks
$stuckThreshold = 30                     # Seconds the title must stay unchanged before we act

function Get-AntigravityWindowTitle {
    try {
        $proc = Get-Process -Name $processName -ErrorAction Stop
        # Some builds may not have a MainWindowTitle (e.g., hidden), fallback to empty string
        return $proc.MainWindowTitle
    } catch {
        return $null
    }
}

Write-Host "[Watchdog] Monitoring Antigravity for stuck state..."
$lastTitle = $null
$stuckSince = $null

while ($true) {
    $title = Get-AntigravityWindowTitle
    if ($title -and $title -like "*$stuckTitle*") {
        if ($title -eq $lastTitle) {
            if (-not $stuckSince) { $stuckSince = Get-Date }
            $elapsed = (Get-Date) - $stuckSince
            if ($elapsed.TotalSeconds -ge $stuckThreshold) {
                Write-Host "[Watchdog] Detected stuck Antigravity (title: '$title') for $($elapsed.TotalSeconds) seconds. Running fix..."
                # Run fix.bat located in the same directory as this script
                $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
                $fixPath = Join-Path $scriptDir "fix.bat"
                if (Test-Path $fixPath) {
                    & $fixPath
                    Write-Host "[Watchdog] Fix script executed. Resetting timer."
                } else {
                    Write-Warning "[Watchdog] fix.bat not found at $fixPath"
                }
                # Reset detection state after fixing
                $stuckSince = $null
                $lastTitle = $null
            }
        } else {
            # Title changed to stuck state, start timer
            $lastTitle = $title
            $stuckSince = Get-Date
        }
    } else {
        # No stuck title, reset state
        $lastTitle = $null
        $stuckSince = $null
    }
    Start-Sleep -Seconds $checkInterval
}
