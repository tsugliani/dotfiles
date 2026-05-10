# Dotfiles (chezmoi)

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/), targeting **macOS** and **Debian 13 (Trixie)** with optional **1Password** integration.

## Quick start

```bash
# Install chezmoi and apply in one step
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply YOUR_REPO_URL

# Or from an existing local copy
chezmoi init && chezmoi apply
```

On first run, `chezmoi init` prompts for:

- **Git full name** and **email**
- **Enable 1Password** (y/n) — installs the CLI and enables SSH agent + secret injection

After apply, reload the shell: `source ~/.zshrc`

## What gets installed

### Bootstrap scripts

Scripts run in numbered order. `run_once_*` execute once ever; `run_onchange_*` re-run when their rendered content changes.

| # | Script | Type | What it does |
|---|--------|------|-------------|
| 00 | `run_once_before_00-install-prereqs` | run_once_before | apt: `build-essential curl file git procps gettext ca-certificates` / macOS: Xcode CLI tools |
| 01 | `run_once_before_01-install-homebrew` | run_once_before | Install Homebrew if not present (skips if already at known paths) |
| 00 | `run_onchange_before_00-check-prerequisites` | run_onchange_before | Color-coded prereq check: sudo, zsh, curl, git, internet, apt, `users` group, Homebrew |
| 02 | `run_onchange_before_02-install-1password-cli` | run_onchange_before | Install 1Password CLI via `brew install --cask` (only when enabled) |
| 05 | `run_onchange_after_05-setup-shell` | run_onchange_after | Clone Oh My Zsh, zsh plugins, TPM, and Catppuccin into user-local paths |
| 09 | `run_onchange_after_09-fix-homebrew-permissions` | run_onchange_after | `chgrp`/`chmod`/setgid on `/home/linuxbrew` for shared multi-user access (Linux only) |
| 10 | `run_onchange_after_10-install-packages` | run_onchange_after | Install apt packages + Homebrew packages from `settings.yaml` |
| 20 | `run_onchange_after_20-setup-neovim` | run_onchange_after | Run `Lazy! sync` to install neovim plugins |

### Package lists

**Linux (apt):** bat, eza, fd-find, fzf, git, git-delta, lazygit, ripgrep, starship, tmux, zoxide

**Linux (Homebrew):** neovim, oh-my-posh

**macOS (Homebrew):** bat, eza, fd, fzf, git, git-delta, lazygit, neovim, oh-my-posh, ripgrep, starship, tmux, zoxide

Edit `.chezmoidata/settings.yaml` to customize.

## What gets configured

### Shell (Zsh)

All shell configuration lives in a single `~/.zshrc` (no `.zshenv`).

- **Oh My Zsh** with plugins: `git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`
- **Oh My Posh** prompt over SSH (with nerd font icons)
- **Homebrew** shellenv sourced early in `.zshrc` (before oh-my-zsh resets PATH)
- **Environment:** XDG dirs, EDITOR/VISUAL (nvim), PAGER (less)
- **Shell integrations:** direnv, zoxide, atuin (history), fzf
- **Aliases:** `ls`/`ll`/`la` (eza), `cat`/`c` (bat), `g` (git), `v` (nvim), `tm` (tmux)
- **Compinit** cached daily with `-u` flag and `DISABLE_COMPFIX=true` for shared Homebrew setups
- **Helper function:** `mkcd` — create directory and cd into it

### Git

- User name/email from `settings.yaml` (or chezmoi init prompt)
- Editor: nvim
- Default branch: main
- SSH commit signing enabled (`gpg.format = ssh`)
- [delta](https://github.com/dandavison/delta) as diff pager with zdiff3 merge conflicts
- Linux: `safe.directory` set for shared Homebrew
- macOS: osxkeychain credential helper / Linux: cache with 1h timeout

### SSH

- `IdentitiesOnly yes`, keepalive 60s, hashed known hosts
- Host entries for `github.com` and `github-work` (personal/work split)
- macOS: `AddKeysToAgent yes`, `UseKeychain yes`

### Tmux

- Prefix: `C-a` (screen-style)
- True color support (`tmux-256color` + `Tc` override)
- Mouse enabled, 100k history, base index 1
- **Catppuccin Mocha** theme cloned to `~/.tmux/plugins/catppuccin`
- Pane splits: `|` horizontal, `-` vertical
- Reload: `prefix + r`

### Neovim

- **LazyVim** distribution with lazy.nvim plugin manager (auto-bootstraps on first launch)
- **Catppuccin Mocha** colorscheme with true color (`termguicolors`)
- Relative line numbers, no line wrap
- Keymap: `<leader>tt` opens terminal

### Plugin/tool paths (user-local)

All plugins are cloned directly into the user's home — no `/usr/share` symlinks:

| Path | Contents |
|------|----------|
| `~/.oh-my-zsh` | Oh My Zsh |
| `~/.oh-my-zsh/custom/plugins/zsh-autosuggestions` | zsh-autosuggestions plugin |
| `~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting` | zsh-syntax-highlighting plugin |
| `~/.tmux/plugins/tpm` | Tmux Plugin Manager |
| `~/.tmux/plugins/catppuccin` | Catppuccin Mocha tmux theme |

`run_onchange_after_05` handles initial clone and detects/replaces any leftover symlinks pointing to `/usr/share`.

## 1Password integration

When enabled (`use_1password: true`):

| Component | Without 1Password | With 1Password |
|-----------|-------------------|----------------|
| **Git signing** | Local SSH key from `settings.yaml` | Includes `~/.gitconfig.1password` |
| **SSH auth** | `IdentityFile` with local keys | `IdentityAgent ~/.1password/agent.sock` |
| **Secrets** | Not managed | `~/.config/zsh/local/1password.zsh` sourced (exports `GITHUB_TOKEN`, etc.) |
| **CLI** | Not installed | Installed via `brew install --cask 1password-cli` |

### Refreshing 1Password-generated files

```bash
op-refresh
```

Renders local-only files via `op inject` from templates in `~/.config/op/templates/`:
- `~/.gitconfig.1password`
- `~/.ssh/config.1password`
- `~/.config/zsh/local/1password.zsh`

## Repo layout

```
.chezmoidata/settings.yaml             # All user settings and package lists
.chezmoi.toml.tmpl                     # Interactive prompts for chezmoi init
dot_zshrc.tmpl                         # Shell config (~/.zshrc)
dot_gitconfig.tmpl                     # Git config (~/.gitconfig)
dot_tmux.conf.tmpl                     # Tmux config (~/.tmux.conf)
dot_config/nvim/                       # Neovim (LazyVim) config
dot_config/zsh/functions.zsh           # Shell helper functions
dot_config/op/templates/               # 1Password op-inject templates
dot_config/1Password/                  # 1Password SSH agent policy
dot_local/bin/op-refresh.tmpl          # 1Password refresh script
private_dot_ssh/                       # SSH config and allowed_signers templates
run_once_before_00-install-prereqs*    # Install system prerequisites
run_once_before_01-install-homebrew*   # Install Homebrew
run_onchange_before_00-check-prereqs*  # Prerequisite check with status table
run_onchange_before_02-install-1p*     # Install 1Password CLI (when enabled)
run_onchange_after_05-setup-shell*     # Clone Oh My Zsh, plugins, TPM, Catppuccin
run_onchange_after_09-fix-homebrew*    # Fix shared Homebrew permissions (Linux)
run_onchange_after_10-install-pkgs*    # Install packages
run_onchange_after_20-setup-neovim*    # Sync neovim plugins
```

## Common tasks

```bash
chezmoi apply                                              # Apply all changes
chezmoi apply --dry-run                                    # Preview changes
chezmoi diff                                               # Show diff of pending changes
chezmoi execute-template < file.tmpl                       # Test template rendering
chezmoi state delete-bucket --bucket=scriptState           # Reset script run state (re-run all scripts)
chezmoi init                                               # Re-run interactive prompts
```

## Shared Homebrew on Linux

This repo deliberately uses a single shared Homebrew install at `/home/linuxbrew/.linuxbrew`, owned by `root:users` with group write and the setgid bit on directories. The alternative — a per-user install in `~/.linuxbrew` — was considered and rejected.

### Why shared, not per-user

- **Bottles only ship for `/home/linuxbrew/.linuxbrew`.** Any other prefix forces Homebrew on Linux to build from source. A fresh `neovim` install would pull a full Python + gcc toolchain and take 30–60 min instead of seconds. Bottles are non-negotiable — that pins the install path.
- **Space efficiency.** One cellar (~1.5 GB on a typical setup) shared by all users, instead of N near-identical copies.
- **Adding a user is one command.** `sudo usermod -aG sudo,users $newuser` and they can `brew install` immediately — no per-user bootstrap, no duplicated toolchain, no second 30-minute build cycle.

### How it's wired up

1. `run_onchange_after_09-fix-homebrew-permissions` chowns the tree to `root:users`, sets `g+rwX`, and applies setgid to every directory so files created by future `brew install` calls inherit the `users` group.
2. `safe.directory` for the Homebrew git repo is set automatically in `.gitconfig` (Linux only).
3. `DISABLE_COMPFIX=true` and `compinit -u` in `.zshrc` silence zsh's "insecure directory" warnings on the group-writable paths.
4. The prerequisite check fails apply if `$USER` isn't in the `users` group — fix with `sudo usermod -aG users $USER` and re-login.

### Adding another user to the box

> ⚠️ **Security warning — trusted users / dev boxes only.**
> The chezmoi bootstrap requires `sudo` (apt installs, Homebrew permission fix). The snippet below adds new users to the `sudo` group, which grants **full root access** to the machine. Only do this for test/dev environments or users you fully trust. On shared or production hosts, provision system packages and the `/home/linuxbrew` permissions out-of-band, give the new user `users` group only, and run a stripped-down apply that skips the privileged scripts.

```bash
sudo usermod -aG sudo,users $newuser           # ⚠️ sudo = full root; trusted users only
sudo cp -r ~/.local/share/chezmoi /home/$newuser/.local/share/
sudo chown -R "$newuser:$newuser" /home/$newuser/.local
sudo -iu "$newuser" chezmoi init && sudo -iu "$newuser" chezmoi apply
```

## Customization

Edit `.chezmoidata/settings.yaml` to change:
- Git identity
- SSH key paths
- 1Password vault/item names
- Package lists per OS

Re-run `chezmoi apply` after changes. Run `source ~/.zshrc` to reload the shell.
