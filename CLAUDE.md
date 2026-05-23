# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a GNU Stow-managed dotfiles repository. Each top-level directory is a stow package where the internal path mirrors `$HOME`. Running `stow <package>` from the repo root symlinks the package's contents into `~`.

## Installation

```bash
# Stow a single package
stow nvim

# Stow all packages at once
stow */
```

Required software is listed in `TODOS.md`. The `ansible/` directory contains an Ansible config intended to automate system setup (library points to a local `ansible-aur` module — not yet fully built out).

## Repository Structure

Each package directory follows the stow convention (`<package>/<path-relative-to-home>`):

- **`nvim/`** — Neovim config (`~/.config/nvim/`)
- **`zsh/`** — Zsh config + oh-my-zsh (`~/.zshrc`, `~/.oh-my-zsh/`)
- **`tmux/`** — tmux config (`~/.tmux.conf`)
- **`sway/`** — Sway WM config + helper scripts (`~/.config/sway/`)
- **`sessionizer/`** — tmux session management scripts (`~/.local/scripts/`)
- **`templates/`** — Project scaffolding scripts (`~/.local/scripts/`)
- **`nushell/`** — Nushell config files (`~/.config/nushell/`)
- **`starship/`** — Starship prompt config (`~/.config/starship.toml`)
- **`ghostty/`** — Ghostty terminal config (`~/.config/ghostty/`)
- **`waybar/`** — Waybar status bar (`~/.config/waybar/`)
- **`kanshi/`** — Wayland display config (`~/.config/kanshi/`)
- **`mako/`** — Wayland notification daemon (`~/.config/mako/`)

## Neovim Architecture

The config uses **lazy.nvim** directly (LazyVim framework is intentionally disabled). Plugin declarations all live in `lua/custom/plugins/` and are auto-imported by `lua/config/lazy.lua`.

Key files:
- `plugin/keymaps.lua` — global keymaps (leader = `<Space>`)
- `plugin/opts.lua` — vim options
- `plugin/filetypes.lua` — filetype-specific settings
- `plugin/floatterminal.lua` — floating terminal
- `plugin/menu.lua` — custom menu
- `after/ftplugin/` — per-filetype overrides (c, lua, fsharp, lean)
- `LuaSnip/` — LuaSnip snippets organized by filetype (`tex/`, `py/`, `all.lua`)

Active LSPs (managed via Mason): `clangd`, `rust_analyzer`, `pyright`, `gopls`, `lua_ls`, `ts_ls`, `hls` (Haskell), `zls` (Zig), `templ`, `bashls`, `marksman`, `neocmake`, `jsonls`, `yamlls`, `tailwindcss`.

Completion: `blink.cmp`. Formatting: `conform.nvim` with autoformat on save (`lua/custom/autoformat.lua`). File nav: `oil.nvim`. Fuzzy find: `telescope` + a custom multigrep picker at `lua/custom/plugins/telescope/multigrep.lua`.

## Tmux / Sessionizer

`~/.local/scripts/tmxses` is a fuzzy session launcher (fzf over `~/dev/` subdirs). Bound in tmux to `prefix + ^f` (new window) and direct binds (`D`=dotfiles, `J`=projects, `K`=university, `H`=home). In zsh, `^f` calls `tmxses` via a zle widget.

`~/.local/scripts/git-tree-sessionizer` creates tmux sessions from git worktrees (fzf over `git worktree list`).

## C++ Project Template

`~/.local/scripts/cppTemplate.sh <name>` scaffolds a C++20 CMake project with `src/`, `include/`, `build/`, `tests/` directories and a `.envrc` using direnv (`use flake`).

## Shell Environment

- `cd` is aliased to `zoxide` (`z`)
- `ls` is aliased to `exa`
- `direnv` hook active for per-project env vars
- Conda (anaconda3) and ghcup initialized in `.zshrc`
- tmux auto-starts on new zsh sessions (unless already inside tmux)
- Starship prompt (replaces oh-my-zsh themes — `ZSH_THEME=""`)

## Sway WM

Mod key is **Alt** (`Mod1`). Vim-style hjkl navigation. Terminal: `ghostty`. Browser: `qutebrowser`. Workspaces 1–10 with icon labels; workspace 2 launches Firefox, 3 ghostty, 5 zathura, 7 obsidian, 8 youtube-music, 9 discord.
