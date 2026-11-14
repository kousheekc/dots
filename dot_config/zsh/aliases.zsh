# Personal aliases and functions — loaded from ~/.zshrc
# Each alias only applies if its tool is installed, so this works on any machine.

has() { command -v "$1" >/dev/null 2>&1; }

# Debian/Ubuntu install bat and fd as `batcat` and `fdfind`
if has bat; then BAT=bat; elif has batcat; then BAT=batcat; alias bat=batcat; fi
if has fd;  then FD=fd;   elif has fdfind; then FD=fdfind; alias fd=fdfind;  fi

# ── Editor ──────────────────────────────────────────────
if has nvim; then
  export EDITOR=nvim VISUAL=nvim   # lazygit, gh, git commit all use this
  alias v='nvim'
fi
alias zshrc='chezmoi edit --apply ~/.zshrc'
alias aliases='chezmoi edit --apply ~/.config/zsh/aliases.zsh'
alias reload='exec zsh'

# ── Better defaults ─────────────────────────────────────
[ -n "$BAT" ] && alias cat="$BAT -pp"   # bat colours, but behaves like cat (no pager)
has btop    && alias top='btop'
has lazygit && alias lg='lazygit'
has just    && alias j='just'

# ── fzf: use fd for listing and bat for previews ────────
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
if [ -n "$FD" ]; then
  export FZF_DEFAULT_COMMAND="$FD --type f --hidden --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FD --type d --hidden --exclude .git"
fi
[ -n "$BAT" ] && export FZF_CTRL_T_OPTS="--preview '$BAT --color=always --style=numbers --line-range=:300 {}'"

# ── Fuzzy functions ─────────────────────────────────────
# vf: fuzzy-find a file and open it in $EDITOR
vf() {
  local f list
  if [ -n "$FD" ]; then list="$FD --type f --hidden --exclude .git"
  else list="find . -type f -not -path '*/.git/*'"; fi
  f=$(eval "$list" | fzf --preview "${BAT:-cat} --color=always --style=numbers {}") && ${EDITOR:-vi} "$f"
}

# fs <text>: search file contents, pick a match, open $EDITOR at that exact line
fs() {
  local hit
  hit=$(rg --line-number --no-heading --color=always "$@" |
        fzf --ansi --delimiter : \
            --preview "${BAT:-cat} --color=always --highlight-line {2} {1}" \
            --preview-window '+{2}/2') || return
  ${EDITOR:-vi} "+$(echo "$hit" | cut -d: -f2)" "$(echo "$hit" | cut -d: -f1)"
}

# gb: fuzzy-switch git branch (most recent first) — replaces Oh My Zsh's `gb` alias
unalias gb 2>/dev/null
gb() {
  local b
  b=$(git branch --sort=-committerdate --format='%(refname:short)' | fzf --preview 'git log --oneline -20 {}') && git switch "$b"
}

# ── eza: modern ls ──────────────────────────────────────
if has eza; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --git --icons --group-directories-first'   # long list + git status
  alias la='eza -a --icons --group-directories-first'          # include hidden files
  alias lt='eza --tree --level=2 --icons --git-ignore'         # tree, 2 levels deep
  alias ltt='eza --tree --level=4 --icons --git-ignore'        # deeper tree
fi
