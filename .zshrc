# ===================================================================
#                       ZSH CONFIGURATION 
# ===================================================================

# ╔══════════════════════════════════════════════════════════════════╗
# ║                           CORE SETUP                             ║
# ╚══════════════════════════════════════════════════════════════════╝

# Initialize completion system
autoload -Uz compinit
compinit

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=green,fg=black,bold"

# Vi Mode
bindkey -v

# ╔══════════════════════════════════════════════════════════════════╗
# ║                          PLUGINS                                 ║
# ╚══════════════════════════════════════════════════════════════════╝

# FZF Tab Plugin
source ~/.config/fzf-tab/fzf-tab.plugin.zsh

# Zsh Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# History Substring Search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Syntax Highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ╔══════════════════════════════════════════════════════════════════╗
# ║                        COMPLETION STYLES                         ║
# ╚══════════════════════════════════════════════════════════════════╝

# Completion formatting
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu no

# FZF Tab styles
zstyle ':fzf-tab:complete:*' fzf-preview '
if [ -d "$realpath" ]; then
    eza --icons -T --level=2 --color=always "$realpath"
elif [ -f "$realpath" ]; then
    bat -n --color=always --line-range :500 "$realpath"
fi
'
zstyle ':fzf-tab:*' switch-group '<' '>'

# Enable dircolors
eval "$(dircolors -b)"

# ╔══════════════════════════════════════════════════════════════════╗
# ║                         HISTORY SETUP                            ║
# ╚══════════════════════════════════════════════════════════════════╝

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# History options
setopt inc_append_history
setopt share_history

# ╔══════════════════════════════════════════════════════════════════╗
# ║                         ZSH OPTIONS                              ║
# ╚══════════════════════════════════════════════════════════════════╝

setopt autocd
setopt correct
setopt complete_in_word

# ╔══════════════════════════════════════════════════════════════════╗
# ║                       ENVIRONMENT VARIABLES                      ║
# ╚══════════════════════════════════════════════════════════════════╝

export PATH="$PATH:$HOME/.local/bin"
export EDITOR=nvim
export TERMINAL=kitty
export FZF_DEFAULT_OPTS="--style=full --layout=reverse --height=50% --tiebreak=length"
export FZF_COMPLETION_TRIGGER=',,'

export PNPM_HOME="/home/facu/.local/share/pnpm"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ╔══════════════════════════════════════════════════════════════════╗
# ║                           ALIASES                                ║
# ╚══════════════════════════════════════════════════════════════════╝

# File operations
alias ls='ls --color=auto'
alias ll='eza -la --color=auto --icons'
alias tree='eza -T'
alias open='xdg-open'

# Navigation
alias fl='y'  

# Editors
alias nv='nvim'
alias vim='nvim'
alias nvimLazy='NVIM_APPNAME=nvimLazyvim nvim'

# Applications
alias ff='fastfetch --logo /home/facu/.config/fastfetch/arch-linux'
alias lgit='lazygit'
alias ldock='lazydocker'
alias pdf="zathura"

# Development
alias bmake="bear -- make"

# FZF utilities
alias fgit='findgit-widget'

alias sddm-preview='sddm-greeter-qt6 --test-mode --theme'

alias ghme='gh api user --jq ".html_url" | xargs xdg-open'

# ╔══════════════════════════════════════════════════════════════════╗
# ║                         FZF SETUP                                ║
# ╚══════════════════════════════════════════════════════════════════╝

# FZF shell extensions
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# FZF completion functions
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
    cd)           fzf --preview 'eza --tree --color=always --icons {} | head -200'   "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'eza -l --color=always --icons {}' "$@" ;;
  esac
}

# ╔══════════════════════════════════════════════════════════════════╗
# ║                         FUNCTIONS                                ║
# ╚══════════════════════════════════════════════════════════════════╝

# Custom history widget with FZF
fzf-history-widget() {
    if command -v fzf > /dev/null; then
        local selected
        selected=$(history -n 1 | tac | fzf --height=40% --reverse --border --prompt="Hist > ")
        if [[ -n $selected ]]; then
            LBUFFER="${selected#*[0-9]  }"
        fi
        zle reset-prompt 
    fi
}

# Yazi wrapper function
y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# Delete last path component (smart backspace)
delete_last_path_component() {
    local path=$BUFFER
    BUFFER=${path%/*}
    [[ -z $BUFFER ]] && BUFFER="/"
    CURSOR=${#BUFFER}
}

# Funcion para buscar proyectos con git (Uso mi script)
findgit-widget() {
    local selected_dir
    selected_dir=$(~/.local/bin/findgit)
    if [[ -n "$selected_dir" ]]; then
        cd "$selected_dir"
    fi
    zle reset-prompt
}

cdroot() {
  local dir
  dir=$(fd . / --type d --hidden --follow --exclude .git \
        | fzf --preview 'eza --tree --color=always --icons {} | head -100') || return
  cd "$dir"
}

fzf-facultad-widget() {
    local selected_dir
    selected_dir=$(fd -t d . ~/Escritorio/Facultad -d 1 | fzf --preview 'eza --color=always -al {}' --preview-window=right:50%)
    if [[ -n "$selected_dir" ]]; then
        cd "$selected_dir"
    fi
    zle reset-prompt
}

# ╔══════════════════════════════════════════════════════════════════╗
# ║                       WIDGET REGISTRATION                        ║
# ╚══════════════════════════════════════════════════════════════════╝

# Register custom widgets
zle -N fzf-history-widget
zle -N delete_last_path_component
zle -N history-substring-search-up
zle -N history-substring-search-down
zle -N findgit-widget
zle -N fzf-facultad-widget

# ╔══════════════════════════════════════════════════════════════════╗
# ║                        KEY BINDINGS                              ║
# ╚══════════════════════════════════════════════════════════════════╝


# History substring search bindings
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

# Up arrow
bindkey '^[[A' history-substring-search-up
# Down arrow
bindkey '^[[B' history-substring-search-down
# Alt j
bindkey '^[j' history-substring-search-down
# Alt k
bindkey '^[k' history-substring-search-up


# Other key bindings
bindkey "^[[Z" reverse-menu-complete
bindkey "^[[3~" delete-char

bindkey '^G' findgit-widget

bindkey '^R' fzf-history-widget
bindkey '^H' delete_last_path_component  

bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^L' clear-screen
bindkey -M viins '^K' kill-line
bindkey -M viins '^?' backward-delete-char

bindkey '^F' fzf-facultad-widget
# ╔══════════════════════════════════════════════════════════════════╗
# ║                      EXTERNAL TOOLS INIT                         ║
# ╚══════════════════════════════════════════════════════════════════╝

# Initialize external tools
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

