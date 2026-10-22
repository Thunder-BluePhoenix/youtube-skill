# Claude YouTube

[![CI](https://github.com/Thunder-BluePhoenix/youtube-skill/actions/workflows/ci.yml/badge.svg)](https://github.com/Thunder-BluePhoenix/youtube-skill/actions/workflows/ci.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)

A [Claude Code](https://claude.com/claude-code) skill for YouTube creators: channel audits, video SEO, retention-engineered scripts, hooks, thumbnail briefs, content strategy, Shorts, analytics, monetization, competitor research, and cross-platform repurposing.

## Install

**macOS / Linux**

```bash
curl -fsSL https://raw.githubusercontent.com/Thunder-BluePhoenix/youtube-skill/main/install.sh | bash
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/Thunder-BluePhoenix/youtube-skill/main/install.ps1 | iex
```

The skill is installed to `~/.claude/skills/youtube`. To remove it, run `uninstall.sh` or `uninstall.ps1` the same way.

## Usage

Start Claude Code and run any command:

| Command | Purpose |
|---------|---------|
| `/youtube audit` | Full channel health audit (4 dimensions) |
| `/youtube seo` | Video SEO package (titles, description, tags, schema) |
| `/youtube script` | Retention-engineered script with pattern interrupts |
| `/youtube hook` | 5 hook variants with drop-off risk ratings |
| `/youtube thumbnail` | Thumbnail brief with 3 A/B variants |
| `/youtube strategy` | Channel positioning and 30/60/90-day milestones |
| `/youtube calendar` | Monthly content calendar with Shorts plan |
| `/youtube shorts` | Shorts production package |
| `/youtube analyze` | Analytics interpretation and priority actions |
| `/youtube repurpose` | Cross-platform content package |
| `/youtube monetize` | Revenue strategy across 7 streams |
| `/youtube competitor` | Competitor analysis with parallel agents |
| `/youtube metadata` | Copy-paste-ready upload package |
| `/youtube ideate` | 10 ranked video ideas with keyword analysis |

You can also just describe what you want ("audit my channel", "write a hook for this video") and the skill routes it.

## Optional: live YouTube data

Most commands work with no setup. The scripts in `execution/` pull real channel, video, and transcript data when you provide credentials:

```bash
pip install google-api-python-client google-auth-oauthlib  # YouTube Data / Analytics API
pip install yt-dlp                                          # transcript fallback
export YOUTUBE_API_KEY=your_key
```

Get an API key from the [Google Cloud Console](https://console.cloud.google.com/apis/library/youtube.googleapis.com). Owner-only analytics require OAuth: save your OAuth client file as `~/.claude/youtube_client_secrets.json` (see `skills/claude-youtube/execution/utils/youtube_auth.py`).

## Repository layout

```
skills/claude-youtube/
  SKILL.md       # Entry point and routing
  sub-skills/    # One instruction file per command
  references/    # On-demand knowledge guides
  templates/     # Channel-type templates
  execution/     # Python data-fetching scripts (stdlib CLI)
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Please also read the [Code of Conduct](CODE_OF_CONDUCT.md) and [Security Policy](SECURITY.md).

## License

[GNU General Public License v3.0](LICENSE)
