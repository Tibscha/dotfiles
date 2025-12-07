# Set up the prompt

#autoload -Uz promptinit
#promptinit
#prompt adam1

# -----------------------------
# History settings
# -----------------------------
setopt histignorealldups sharehistory


# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# -----------------------------
# Keybindings
# -----------------------------
bindkey -e

# -----------------------------
# Completions
# -----------------------------
autoload -Uz compinit
compinit

#zstyle ':completion:*' auto-description 'specify: %d'
#zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true

#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# -----------------------------
# FZF (interactive search)
# -----------------------------
# Ctrl+R = History-Suche
# Ctrl+T = Datei-Suche
# Alt+C = Ordner-Suche
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
    source /usr/share/doc/fzf/examples/key-bindings.zsh

[ -f /usr/share/doc/fzf/examples/completion.zsh ] && \
    source /usr/share/doc/fzf/examples/completion.zsh

# -----------------------------
# Starship Prompt
# -----------------------------
eval "$(starship init zsh)"

# -----------------------------
# Plugins
# -----------------------------
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

# Autosuggestions MUST come before syntax highlighting
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#777777'

# Syntax highlighting MUST be loaded last
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
