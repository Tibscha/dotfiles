# -----------------------------
# Zinit setup
# -----------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"


# -----------------------------
# History settings
# -----------------------------
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# -----------------------------
# Keybindings
# -----------------------------
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# -----------------------------
# Keybindings
# -----------------------------
alias ls='ls --color'

# -----------------------------
# Completions
# -----------------------------
autoload -Uz compinit && compinit

zinit cdreplay -q

#zstyle ':completion:*' auto-description 'specify: %d'
#zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true

#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# -----------------------------
# FZF (interactive search)
# -----------------------------
# Ctrl+R = History-Suche
# Ctrl+T = Datei-Suche
# Alt+C = Ordner-Suche
#[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
#    source /usr/share/doc/fzf/examples/key-bindings.zsh

#[ -f /usr/share/doc/fzf/examples/completion.zsh ] && \
#    source /usr/share/doc/fzf/examples/completion.zsh

# -----------------------------
# Starship Prompt
# -----------------------------
#eval "$(starship init zsh)"

# -----------------------------
# Plugins
# -----------------------------
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

#source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

# Autosuggestions MUST come before syntax highlighting
#source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#777777'

# Syntax highlighting MUST be loaded last
#source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
