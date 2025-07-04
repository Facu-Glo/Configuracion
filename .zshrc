# ---------- COMPLETIONS ----------
autoload -Uz compinit
compinit
# >>> FZF-TAB INICIO <<<
source ~/.fzf-tab/fzf-tab.plugin.zsh
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

eval "$(dircolors -b)"
zstyle ':completion:*' menu no

# ---------- AUTOSUGGESTIONS ----------
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ---------- SYNTAX HIGHLIGHTING ----------
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ---------- HISTORY SUBSTRING SEARCH ----------
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N history-substring-search-up
zle -N history-substring-search-down

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[Z" reverse-menu-complete

if command -v fzf > /dev/null; then

  fzf-history-widget() {
    local selected
    selected=$(history -n 1 | tac | fzf --height=40% --reverse --border --prompt="Hist > ")
    if [[ -n $selected ]]; then
      LBUFFER="${selected#*[0-9]  }"
    fi
    zle reset-prompt 
  }
  zle -N fzf-history-widget
  bindkey '^R' fzf-history-widget

fi

# ---------- KEYBINDING ----------
bindkey "^[[3~" delete-char

# ---------- ALIASES ----------
alias ll='ls -la --color=auto'
alias ls='ls --color=auto'
alias ff='fastfetch'
alias fl='y'
alias nv='nvim'
alias vim='nvim'
alias lgit='lazygit'
alias bmake="bear -- make"
alias open='xdg-open'
alias pdf="zathura"
alias fzfr="fd . / --type d --hidden --follow --exclude .git | fzf --preview 'tree -C {} | head -100'" # fzf desde root, aunque con ** hace lo mismo y mas
# alias fzf="fzf --style full --layout reverse --height 40% --preview 'bat --color=always {}'"

# ---------- OPTIONS ----------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history
setopt share_history
setopt autocd
setopt correct
setopt complete_in_word

# ---------- YAZI ----------
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# ---------- PROMPT ----------
eval "$(starship init zsh)"

# ---------- ZOXIDE ----------
eval "$(zoxide init zsh)"

# ---------- PATH ----------
export PATH="$PATH:$HOME/.local/bin"
export EDITOR=nvim
export TERMINAL=kitty
export FZF_DEFAULT_OPTS="--style=full --layout=reverse --height=40% --tiebreak=begin"

# ---------- FZF ----------
# fzf shell extensions
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude .git . "$1"
}

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}

# ---------- FUNCIONES ----------
delete_last_path_component() {
  local path=$BUFFER
  BUFFER=${path%/*}
  [[ -z $BUFFER ]] && BUFFER="/"
  CURSOR=${#BUFFER}
}

zle -N delete_last_path_component

bindkey '^H' delete_last_path_component  # Ctrl+Backspace
