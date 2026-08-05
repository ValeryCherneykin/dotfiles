# Zsh configuration

# Fast compinit
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Prompt
setopt PROMPT_SUBST
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' git:(%F{red}%b%f)'
zstyle ':vcs_info:git:*' actionformats ' git:(%F{red}%b%f|%a)'

precmd() { vcs_info }

PROMPT='%F{cyan}%c%f${vcs_info_msg_0_} %(?:%F{green}➜ :%F{red}➜ )%f'

# PATH
export PATH="$HOME/dotfiles/bin:$HOME/.local/bin:$HOME/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Tool settings
export BAT_THEME="Kanagawa"
export BAT_STYLE="numbers,changes,header"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Vi mode
bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

zle-line-init() {
    echo -ne "\e[5 q"
}
zle -N zle-line-init

# Plugins (installed via pacman: zsh-autosuggestions, zsh-syntax-highlighting)
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi

# Syntax highlighting must load last
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_MAXLENGTH=300
fi

# FZF (installed via pacman)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border \
--color=fg:#c5c9c5,bg:#0d0c0c,hl:#7fb4ca \
--color=fg+:#dcd7ba,bg+:#1d1c19,hl+:#7fb4ca \
--color=info:#6a9589,prompt:#c0a36e,pointer:#957fb8 \
--color=marker:#e46876,spinner:#957fb8,header:#7fb4ca"

[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# Zoxide - smart cd
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Aliases
alias v='nvim'
alias vim='nvim'
alias vi='nvim'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias cd='z'
alias find='fd'
alias grep='rg'
alias cat='bat'

alias ls='eza --icons'
alias ll='eza -lah --icons --git'
alias la='eza -A --icons'
alias l='eza --icons'
alias lt='eza --tree --level=2 --icons'

alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'
alias gb='git branch'

alias gor='go run .'
alias gob='go build'
alias got='go test ./...'
alias gom='go mod tidy'
alias golint='golangci-lint run'

alias c='clear'
alias reload='exec zsh'
alias top='btop'
alias help='tldr'
alias fetch='fastfetch'
alias photo='photo-mode'
alias photo-alt='photo-mode-alt'

# Keybindings
bindkey -s '^F' 'dev\n'
bindkey -s '^N' 'dev-new\n'
bindkey -s '^[v' 've\n'
bindkey '^ ' autosuggest-accept

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Options
unsetopt BEEP
unsetopt LIST_BEEP
unsetopt HIST_BEEP
setopt AUTO_CD
setopt CORRECT
setopt EXTENDED_GLOB

autoload -U select-word-style
select-word-style bash

[[ ! -d ~/.zsh/cache ]] && mkdir -p ~/.zsh/cache

eval "$(starship init zsh)"
