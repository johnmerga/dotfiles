# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme
ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="true"
autoload -Uz compinit





# zinit configuration for zsh
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# powerlevel10k configuration with zinit
# zinit ice depth=1 zinit light romkatv/powerlevel10k

## Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.


#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi
#
## Set up the prompt
#
#autoload -Uz promptinit
#promptinit
#prompt adam1
#
#setopt histignorealldups sharehistory
#
## Use emacs keybindings even if our EDITOR is set to vi
#bindkey -e
#
## Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
#HISTSIZE=1000
#SAVEHIST=1000
#HISTFILE=~/.zsh_history
#
##
#
## Zsh Alias (same as Bash)
alias ls='ls --color=auto'
#alias go-store='cd ~/Documents/edu/projects/typescript/project/Store143-API/'
alias go-e='cd ~/Documents/edu/projects/typescript/project/ERAP-Backend/'
alias go-go='cd ~/Documents/edu/projects/Go/Mastering_Go'
alias go-d='cd ~/Documents/edu/projects/'
alias go-w='cd ~/Documents/work/mereb/'
alias con-su-dev='ssh -i ~/server/gcp/sulala_gcp developer@34.18.54.116'
alias inv='nvim $(fzf --preview "cat {}")'
# alias wg='~/Desktop/Desktop/wireguard_script.sh'
alias src='source ./env/bin/activate'

#
#
## bun
#export BUN_INSTALL="$HOME/.bun"
#export PATH=$BUN_INSTALL/bin:$PATH
#
## nvm
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
## Zsh Function (same as Bash)
#my_function() {
#    echo "This is my custom function"
#}
## Use modern completion system
autoload -Uz compinit
#compinit
#
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
#
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
source ~/powerlevel10k/powerlevel10k.zsh-theme
#POWERLEVEL9K_MODE='nerdfont-complete'
#
## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
##env
#. "$HOME/.cargo/env"

# configure go envirement
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
function go_version {
    if [ -f "go.mod" ]; then
        v=$(grep -E '^go \d.+$' ./go.mod | grep -oE '\d.+$')
        if [[ ! $(go version | grep "go$v") ]]; then
          echo ""
          echo "About to switch go version to: $v"
          if ! command -v "$HOME/go/bin/go$v" &> /dev/null
          then
            echo "run: go install golang.org/dl/go$v@latest && go$v download && sudo cp \$(which go$v) \$(which go)"
            return
          fi
          sudo cp $(which go$v) $(which go)
        fi
    fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#
## bun completions
#[ -s "/home/john/.bun/_bun" ] && source "/home/john/.bun/_bun"


# python


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#####################################################################################################################--2024-07-14--#######################################################################################################################
# added configuration after installing zinit date: 2024-07-14
zinit light zsh-users/zsh-syntax-highlighting # syntax highlighting for zsh shell commands
zinit light zsh-users/zsh-completions # completion for zsh commands
zinit light zsh-users/zsh-autosuggestions 


# Load completions
autoload -Uz compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# keybindings
# bindkey -e # Use emacs keybindings even if our EDITOR is set to vi
# accept suggestions with the Alt+j key combination
bindkey '^j' autosuggest-accept
bindkey '^p' history-search-backward # Search history backward with page up
bindkey '^n' history-search-forward # Search history forward with page down

# history
HISTSIZE=1000 # Keep 5000 lines of history within the shell
HISTFILE=~/.zsh_history # Save 5000 lines of history to ~/.zsh_history
SAVEHIST=$HISTSIZE # Save 5000 lines of history within the shell
HISTDUP=erase # Erase duplicates in the history file
setopt append_history # Append history to the history file
setopt share_history # Share history between all sessions
setopt hist_ignore_space # Ignore commands that start with a space
setopt hist_ignore_dups # Ignore duplication command history line
setopt hist_ignore_all_dups # Ignore all duplication command history line
setopt hist_save_no_dups # Do not save duplication command history line
setopt hist_find_no_dups # Do not find duplication command history line

# completion settings
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#custom kill programs
alias kp="ps aux | fzf | awk '{print \$2}' | xargs kill -9"
export PATH=$HOME/bin:$PATH
