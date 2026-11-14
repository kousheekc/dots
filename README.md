# dots

My terminal environment for macOS and Linux (Ubuntu/Debian, Fedora, Arch, and headless servers or clusters), managed with [chezmoi](https://chezmoi.io).

This repo holds **configs only**: install the tools yourself (checklist below), then apply. Every tool is optional. If something isn't installed, its shell setup and aliases are skipped silently.

## Set up a new machine

1. Install the tools you want ([checklist](#install-checklist)).
2. Apply the configs (installs chezmoi to `~/.local/bin`, no sudo needed):

   ```sh
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply kousheekc/dots
   ```

   You'll be asked three things, once per machine. The answers stay in `~/.config/chezmoi/chezmoi.toml` and never enter the repo:

   | Prompt | Used for |
   | --- | --- |
   | Git name / email | `~/.gitconfig` |
   | Machine profile | `desktop` (default on macOS or with a display) or `server` (headless; skips kitty config) |

3. Open a new shell.

## What's managed

| Tool | Config |
| --- | --- |
| zsh + oh-my-zsh | `~/.zshenv`, `~/.zprofile`, `~/.zshrc`, `~/.config/zsh/aliases.zsh` |
| bash (Linux) | `~/.bash_profile`: hands interactive logins to zsh where `chsh` isn't allowed |
| [kitty](https://sw.kovidgoyal.net/kitty/) | `~/.config/kitty/` (desktop only; macOS-only options templated) |
| [starship](https://starship.rs) | `~/.config/starship.toml` (full default config, ready to customise) |
| herdr | `~/.config/herdr/config.toml` |
| Neovim ([LazyVim](https://lazyvim.org)) | `~/.config/nvim/`; `lazy-lock.json` pins plugin versions |
| git + [delta](https://github.com/dandavison/delta) | `~/.gitconfig` (delta settings only added if delta is installed) |
| [lazygit](https://github.com/jesseduffield/lazygit) | `~/.config/lazygit/config.yml` (full default config) |
| [bat](https://github.com/sharkdp/bat) | `~/.config/bat/config` |
| [atuin](https://atuin.sh) | `~/.atuin/config.toml` |
| [btop](https://github.com/aristocratos/btop) | `~/.config/btop/` |
| [superfile](https://superfile.netlify.app) | `~/.config/superfile/` |
| gh | `~/.config/gh/config.yml` (never `hosts.yml`) |
| Claude Code | `~/.claude/settings.json`, skills in `~/.agents/skills/` |

`XDG_CONFIG_HOME` is set to `~/.config` on every OS, so lazygit and superfile use the same path on macOS as on Linux.

## Install checklist

| Tool | macOS (Homebrew) | Ubuntu / Debian | Fedora | Arch | No sudo (clusters) |
| --- | --- | --- | --- | --- | --- |
| zsh | built in | `zsh` | `zsh` | `zsh` | `pixi global install zsh` |
| oh-my-zsh | `git clone https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh` | same | same | same | same |
| zsh-autosuggestions, zsh-syntax-highlighting | clone into `~/.oh-my-zsh/custom/plugins/` | same | same | same | same |
| kitty (desktop) | `--cask kitty` | [installer](https://sw.kovidgoyal.net/kitty/binary/) | `kitty` | `kitty` | n/a |
| starship | `starship` | `curl -sS https://starship.rs/install.sh \| sh` | same | `starship` | install script with `-b ~/.local/bin` |
| Neovim | `neovim` | [release tarball](https://github.com/neovim/neovim/releases) (apt is too old) | `neovim` | `neovim` | release tarball |
| fzf, ripgrep, fd, bat, zoxide, eza, btop | all in Homebrew | `fzf ripgrep fd-find bat zoxide eza btop` | same names | same names (`fd`) | [mise](https://mise.jdx.dev) / `pixi global install` |
| atuin | `atuin` | `curl --proto '=https' -LsSf https://setup.atuin.sh \| sh` | same | `atuin` | install script |
| lazygit, delta, just, gh | all in Homebrew | `gh` via apt; others via GitHub releases | `lazygit` (COPR), `git-delta`, `just`, `gh` | all in pacman | mise |
| superfile | `superfile` | `bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"` | same | `superfile` (AUR) | install script |
| herdr | herdr installer | herdr installer | same | same | same |
| uv / pixi | `curl -LsSf https://astral.sh/uv/install.sh \| sh` · `curl -fsSL https://pixi.sh/install.sh \| sh` | same | same | same | same |
| Rust | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` | same | same | same | same |
| miniconda | [installer](https://docs.anaconda.com/miniconda/) into `~/miniconda3` | same | same | same | same (or the cluster's module) |
| Claude Code | `curl -fsSL https://claude.ai/install.sh \| bash` | same | same | same | same |

After installing:

- **herdr:** run `herdr integration install claude` to set up the agent-state hook.
- **Neovim:** the first launch installs plugins at the versions in `lazy-lock.json`.
- **Servers:** if you SSH in from kitty, copy its terminfo once: `infocmp -x xterm-kitty | ssh <host> tic -x -`.
- **Re-run `chezmoi apply`** after installing delta, so its git settings get added.

## Day-to-day

| Task | Command |
| --- | --- |
| Edit a config (applies on save) | `chezmoi edit --apply ~/.zshrc` (aliases: `zshrc`, `aliases`) |
| See what would change | `chezmoi diff` |
| Pull updates from GitHub and apply | `chezmoi update` |
| Copy a changed live file back into the repo | `chezmoi re-add <file>` (templates: `chezmoi merge <file>`) |
| Commit and push | `chezmoi cd`, then `git commit` / `git push` |

**Machine-specific extras** (cluster `module load`s, local env vars) go in `~/.zshrc.local` or `~/.bash_profile.local`. They're sourced if present and never tracked.
