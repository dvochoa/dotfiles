# My Dotfiles

## Setup
1. Install [oh-my-zsh](https://ohmyz.sh/)
2. Install brew packages by running `./brew_install_packages.sh`
3. Download or copy and paste the contents of whichever dotfiles you'd like to use and edit/remove
   the fields that seem inappropriate to you (e.g. the user information in `.git_config`). If you'd
   like you can also clone this repo and symlink its files to keep your dotfiles up to date with
   changes here.
4. Run `source <file_name>` after bringing in any changes so that they take effect immediately.

## Coding Agents

`agents/AGENTS.md` is the shared instruction source for coding agents.

- Cluade: Link `claude/` to `~/.claude` and `agents/` to `~/.agents`. 
- Codex: Link only `.codex/config.toml`, `.codex/AGENTS.md`, and `.codex/hooks.json` into
  `~/.codex`; leave Codex's auth, sessions, caches, and runtime state local. Link individual
  `.codex/skills/*` directories into `~/.codex/skills/`.

## Terminal

[Herdr](https://herdr.dev) is the terminal multiplexer, installed via Homebrew (see
`brew_install_packages.sh`) rather than its `install.sh`, so updates run through
`brew upgrade` and not `herdr update`. Link only `herdr/config.toml` into
`~/.config/herdr/`; leave its sockets, logs, and `session.json` runtime state local. Keybindings
there mirror `.tmux.conf` (`ctrl+s` prefix, `hjkl` pane focus, arrow-key splits). Apply changes
with `herdr server reload-config`; validate with `herdr config check`.

Two herdr artifacts are generated from the installed binary and deliberately not tracked here —
both are version-stamped and go stale on upgrade. Run these on each new machine, and again after
every `brew upgrade herdr`:

```sh
# agent skill: teaches Claude Code the herdr CLI
mkdir -p ~/.claude/skills/herdr && herdr --skill > ~/.claude/skills/herdr/SKILL.md

# state-reporting hook: writes ~/.claude/hooks/herdr-agent-state.sh, which lets herdr
# track agent state and resume conversations after a server restart
herdr integration install claude
```

The `SessionStart` entry the hook installer adds to `claude/settings.json` *is* tracked here, so the
script must exist locally or that hook fires against a missing file. Verify with
`herdr integration status`.

## Terminal Theme
I use the default MacOS Terminal App with the following settings:
- Basic Profile
- Hack Nerd Font Regular 12
- Antialias text disabled
- Block Cursor
- Blink Cursor enabled

## Future Improvements
- Introduce script for packages installed via non-homebrew package managers such as npm
- Include a more holistic install/setup script
- Could consider integrating with something like [chezmoi](https://www.chezmoi.io/) to make this more straightforward and feature rich.
