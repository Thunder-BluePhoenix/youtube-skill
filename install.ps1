#!/usr/bin/env pwsh
# Claude YouTube Installer for Windows (also works with pwsh on macOS/Linux)

# Wrapped in a function so `irm ... | iex` can bail out with `return`
# instead of `exit`, which would close the user's shell.
function Install-ClaudeYouTube {
    $ErrorActionPreference = "Stop"

    Write-Host "=== Installing claude-youtube ===" -ForegroundColor Cyan
    Write-Host ""

    # Check prerequisites
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "Error: Git is required but not installed." -ForegroundColor Red
        return
    }

    # Set paths ($HOME and GetTempPath work on every OS; USERPROFILE/TEMP are Windows-only)
    $SkillDir = [IO.Path]::Combine($HOME, ".claude", "skills", "youtube")
    $RepoUrl = "https://github.com/Thunder-BluePhoenix/youtube-skill"
    $RawUrl = "https://raw.githubusercontent.com/Thunder-BluePhoenix/youtube-skill/main"
    $TempDir = Join-Path ([IO.Path]::GetTempPath()) "claude-youtube-install-$(Get-Random)"

    try {
        Write-Host "Downloading claude-youtube..." -ForegroundColor Yellow
        # No 2>&1 here: in Windows PowerShell 5.1 redirected git stderr becomes a terminating error
        git clone --quiet --depth 1 $RepoUrl $TempDir
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error: failed to download $RepoUrl" -ForegroundColor Red
            return
        }

        # Replace any previous install so files removed upstream don't linger
        Write-Host "Installing skill files..." -ForegroundColor Yellow
        if (Test-Path $SkillDir) {
            Remove-Item -Recurse -Force $SkillDir
        }
        New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
        Copy-Item -Recurse -Force (Join-Path $TempDir "skills/claude-youtube/*") $SkillDir
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
