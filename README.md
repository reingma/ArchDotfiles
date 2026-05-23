# Dotfiles

Arch Linux dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Fresh install

### 1. Install Ansible

```bash
sudo pacman -S ansible
```

### 2. Clone this repo

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
```

### 3. Install Ansible collections

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

### 4. Run the playbook

```bash
ansible-playbook ansible/playbook.yml --ask-become-pass
```

This installs all packages, stows dotfiles to `~`, and sets zsh as the default shell. Paru is bootstrapped automatically if not already present.

## Stowing individual packages

```bash
stow nvim        # single package
stow */          # everything
```

## Dependencies

See `TODOS.md` for the full software list. Everything in there is covered by the Ansible playbook.
