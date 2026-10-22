#!/usr/bin/env pwsh
# Claude YouTube Installer for Windows (also works with pwsh on macOS/Linux)
# Set CLAUDE_YOUTUBE_SRC to a local checkout to install from it instead of GitHub (used by CI).

# Wrapped in a function so `irm ... | iex` can bail out with `return`
# instead of `exit`, which would close the user's shell.
function Install-ClaudeYouTube {
    $ErrorActionPreference = "Stop"
    $ProgressPreference = "SilentlyContinue"  # the progress bar makes Invoke-WebRequest very slow on 5.1

    Write-Host "=== Installing claude-youtube ===" -ForegroundColor Cyan
    Write-Host ""

    # $HOME and GetTempPath work on every OS; USERPROFILE/TEMP are Windows-only
    $SkillDir = [IO.Path]::Combine($HOME, ".claude", "skills", "youtube")
    $ArchiveUrl = "https://github.com/Thunder-BluePhoenix/youtube-skill/archive/refs/heads/main.zip"
    $RawUrl = "https://raw.githubusercontent.com/Thunder-BluePhoenix/youtube-skill/main"
    $TempDir = Join-Path ([IO.Path]::GetTempPath()) "claude-youtube-install-$(Get-Random)"

    try {
        if ($env:CLAUDE_YOUTUBE_SRC) {
            $Src = $env:CLAUDE_YOUTUBE_SRC
        } else {
            Write-Host "Downloading claude-youtube..." -ForegroundColor Yellow
            New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
            $Zip = Join-Path $TempDir "main.zip"
            # Windows PowerShell 5.1 can default to TLS 1.0, which GitHub rejects
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -Uri $ArchiveUrl -OutFile $Zip -UseBasicParsing
            Expand-Archive -Path $Zip -DestinationPath $TempDir
            $Src = Join-Path $TempDir "youtube-skill-main"
        }

        $SkillSrc = [IO.Path]::Combine($Src, "skills", "claude-youtube")
        if (-not (Test-Path (Join-Path $SkillSrc "SKILL.md"))) {
            Write-Host "Error: skill files not found in $Src" -ForegroundColor Red
            return
        }

        # Replace any previous install so files removed upstream don't linger
        Write-Host "Installing skill files..." -ForegroundColor Yellow
        if (Test-Path $SkillDir) {
            Remove-Item -Recurse -Force $SkillDir
        }
        New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
        Copy-Item -Recurse -Force (Join-Path $SkillSrc "*") $SkillDir
    } catch {
        Write-Host "Installation failed: $($_.Exception.Message)" -ForegroundColor Red
        return
    } finally {
        if (Test-Path $TempDir) {
            Remove-Item -Recurse -Force $TempDir
        }
    }

    Write-Host ""
    Write-Host "claude-youtube installed to $SkillDir" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Cyan
    Write-Host "  1. Start Claude Code:  claude"
    Write-Host "  2. Run commands:       /youtube audit"
    Write-Host ""
    Write-Host "To uninstall: irm $RawUrl/uninstall.ps1 | iex"
}

Install-ClaudeYouTube
