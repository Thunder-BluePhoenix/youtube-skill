#!/usr/bin/env pwsh
# claude-youtube uninstaller for Windows (also works with pwsh on macOS/Linux)

$ErrorActionPreference = "Stop"

Write-Host "=== Uninstalling claude-youtube ===" -ForegroundColor Cyan
Write-Host ""

# Join-Path only takes two parts on Windows PowerShell 5.1, so use IO.Path
# Claude Code, then Codex CLI / Gemini CLI
foreach ($SkillDir in @(
    [IO.Path]::Combine($HOME, ".claude", "skills", "youtube"),
    [IO.Path]::Combine($HOME, ".agents", "skills", "youtube")
)) {
    if (Test-Path $SkillDir) {
        Remove-Item -Recurse -Force $SkillDir
        Write-Host "  Removed: $SkillDir" -ForegroundColor Green
    } else {
        Write-Host "  Not installed: $SkillDir" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== claude-youtube uninstalled ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Restart Claude Code to complete removal." -ForegroundColor Yellow
