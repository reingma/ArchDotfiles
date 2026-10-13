# Dotfiles

Arch Linux dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## How it works

Every top-level directory is a **stow package**. Inside a package, paths mirror
`$HOME`, so `nvim/.config/nvim/init.lua` ends up at `~/.config/nvim/init.lua`.
Running `stow <package>` from the repo root creates symlinks in `~` (the parent of
`~/.dotfiles`, which is stow's default target) pointing back into the repo. Edits
made through either path change the same file, so they're tracked by git.

```
~/.dotfiles/nvim/.config/nvim/   ──stow nvim──▶   ~/.config/nvim -> ../.dotfiles/nvim/.config/nvim
~/.dotfiles/zsh/.zshrc           ──stow zsh───▶   ~/.zshrc       -> .dotfiles/zsh/.zshrc
```

### Packages

| Package       | Links to                                             |
| ------------- | ---------------------------------------------------- |
| `cheatsheet`  | `~/.local/scripts/cheat-sh`, `~/.local/scripts/data` |
| `gh`          | `~/.config/gh/config.yml` (`hosts.yml` is ignored)   |
| `ghostty`     | `~/.config/ghostty/`                                 |
| `git`         | `~/.config/git/config`, `~/.config/git/ignore`       |
| `go`          | `~/.config/go/env` (GOPATH/GOBIN in XDG dirs)        |
| `kanshi`      | `~/.config/kanshi/`                                  |
| `mako`        | `~/.config/mako/`                                    |
| `nushell`     | `~/.config/nushell/`                                 |
| `nvim`        | `~/.config/nvim/`                                    |
| `sessionizer` | `~/.local/scripts/tmxses`, `git-tree-sessionizer`    |
| `starship`    | `~/.config/starship.toml`                            |
| `sway`        | `~/.config/sway/`, `~/.local/scripts_no_path/`       |
| `templates`   | `~/.local/scripts/{cppTemplate.sh,pr-template}`, `~/.local/share/pr-templates/` |
| `tmux`        | `~/.tmux.conf`                                       |
| `user-dirs`   | `~/.config/user-dirs.dirs`, `user-dirs.locale`       |
| `wallpapers`  | `~/Pictures/stormlight.png`                          |
| `waybar`      | `~/.config/waybar/`                                  |
| `zathura`     | `~/.config/zathura/`                                 |
| `zsh`         | `~/.zshrc`, `~/.oh-my-zsh/`                          |

## Everyday commands

Always run stow from the repo root (`cd ~/.dotfiles`).

```bash
stow nvim              # link a package
stow -R nvim           # restow: prune stale links and pick up new files
stow -D nvim           # unlink a package (repo files are untouched)
stow -n -v nvim        # dry run: show what would happen without doing it
stow */                # link every package
```

> **Never run `stow .`** — it treats the whole repo as one package and links every
> top-level directory straight into `~` (`~/nvim`, `~/zsh`, ...). If it happens,
> undo it with `stow -D .`.

### When do I need to restow?

Stow "folds" a directory into a single symlink when only one package owns it. For
example `~/.config/nvim` is one symlink to the whole directory, so new files added
under `nvim/.config/nvim/` show up immediately — no restow needed.

When several packages share a directory, stow creates a real directory and links
each file individually. `~/.local/scripts` is shared by `cheatsheet`,
`sessionizer` and `templates`, so **adding, renaming or removing a script there
requires `stow -R <package>`**. A restow also cleans up links left dangling by
moved or deleted files.

### Adding a new config

```bash
# 1. create the package, mirroring the path under $HOME
mkdir -p ~/.dotfiles/foo/.config/foo

# 2. move the existing config into it
mv ~/.config/foo/config ~/.dotfiles/foo/.config/foo/

# 3. link it back
cd ~/.dotfiles && stow foo
```

If stow reports `existing target is not owned by stow`, a real file is sitting where
the link should go. Either move it into the package (step 2) or let stow do it with
`stow --adopt foo` — this **overwrites the repo copy with the file from `~`**, so
check `git diff` afterwards and `git checkout` anything you want to keep.

## Git and GitHub

### git

`git/.config/git/config` holds everything except identity: `user.name` and
`user.email` stay in an untracked `~/.gitconfig` (git reads both files).

- Diffs and `git add -p` go through [delta](https://github.com/dandavison/delta);
  `n` / `N` jump between files.
- `git pull` rebases, `git push` sets the upstream on first push, `git fetch` prunes.
- `https://github.com/...` URLs are rewritten to SSH, so an SSH key registered with
  GitHub is required for cloning anything from there.
- `git/.config/git/ignore` is the global ignore file.

### gh

`gh/.config/gh/config.yml` is tracked. The token lives in `~/.config/gh/hosts.yml`,
which is gitignored; on a new machine run `gh auth login -h github.com` (choose SSH).

`gh config set` and `gh alias set` write through the symlink, so they show up here as
diffs.

`origin` is always the default repo, including in forks that also have an `upstream`
remote, so `gh` never asks which one to use. That comes from `[remote "origin"]
gh-resolved = base` in the git config. To target another remote in one repo, run
`gh repo set-default` there.

Aliases:

| Alias        | Runs                                       | Use                              |
| ------------ | ------------------------------------------ | -------------------------------- |
| `gh co 123`  | `gh pr checkout 123`                       | check out a PR locally           |
| `gh pv`      | `gh pr view --web`                         | open this branch's PR in browser |
| `gh rv`      | `gh repo view --web`                       | open the repo in browser         |
| `gh mine`    | `gh search prs --author=@me --state=open`  | my open PRs, all repos           |
| `gh reviews` | `gh search prs --review-requested=@me ...` | PRs waiting on my review         |

Everyday commands:

```bash
gh pr create              # open a PR for the current branch (uses the repo's PR template)
gh pr create --draft --fill   # draft PR, title and body from the commits
gh pr status              # PRs for this branch, mine, and review requests in this repo
gh pr checks --watch      # follow CI for the current PR
gh pr diff                # the PR diff, through delta
gh pr merge --squash --delete-branch
gh repo clone owner/name
gh repo fork --remote     # fork and add the remote
gh issue list / gh issue create
gh run list / gh run watch    # GitHub Actions
```

In Neovim the same things are under `<leader>o` (octo) and `<leader>g` (diffview);
see `nvim/.config/nvim/README.md`.

### PR templates

Templates are Markdown files in `templates/.local/share/pr-templates/` (linked to
`~/.local/share/pr-templates/`). `pr-template` copies one into the current repo as
`.github/pull_request_template.md`.

```bash
pr-template linear       # install the "linear" template in this repo
pr-template              # pick one with fzf (with preview)
pr-template -l linear    # install but keep it out of git (.git/info/exclude)
pr-template -f linear    # overwrite an existing template without asking
pr-template -L           # list templates
pr-template -e linear    # edit a template, or create it if it doesn't exist
```

Without `-l` the file is left untracked for you to commit; once it is on the default
branch GitHub pre-fills every new PR with it, for everyone. Use `-l` in repos where
you don't own the conventions and only want the template for your own
`gh pr create`.

To add a template, drop a new `.md` file in the directory (or `pr-template -e name`).
No restow is needed.

## Fresh install

```bash
# 1. core packages
sudo pacman -S --needed base-devel git git-delta github-cli stow ripgrep fd fzf jq yq direnv zoxide eza \
  zsh nushell neovim ghostty tmux starship \
  sway swayidle swaylock waybar mako kanshi grim brightnessctl wmenu wl-clipboard pavucontrol \
  qutebrowser zathura zathura-pdf-mupdf obsidian discord \
  clang sqlite go docker docker-buildx docker-compose terraform

# 2. paru (AUR helper)
git clone --depth 1 https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
(cd /tmp/paru-bin && makepkg -si)

# 3. AUR packages
paru -S carapace-bin youtube-music-bin htmlq ttf-sourcecodepro-nerd

# 4. dotfiles
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles && stow */

# 5. shell + services
chsh -s /usr/bin/zsh
sudo systemctl enable --now docker.socket
sudo usermod -aG docker "$USER"   # log out/in afterwards
```

TeX Live is installed separately from [tug.org](https://tug.org/texlive/) under
`/usr/local/texlive/` rather than via pacman.

On first launch Neovim bootstraps lazy.nvim, installs plugins, and Mason installs
the language servers and tools listed in `nvim/.config/nvim/lua/custom/plugins/lsp.lua`.
