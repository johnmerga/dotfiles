# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit configuration for zsh
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Initialize completions
autoload -Uz compinit && compinit

# Aliases
alias ls='ls --color=auto'
alias go-e='cd ~/Documents/edu/projects/typescript/project/ERAP-Backend/'
alias go-go='cd ~/Documents/edu/projects/Go/Mastering_Go'
alias go-d='cd ~/Documents/edu/projects/'
alias go-w='cd ~/Documents/work/mereb/'
alias con-su-dev='ssh -i ~/server/gcp/sulala_gcp developer@34.18.54.116'
alias inv='nvim $(fzf --preview "cat {}")'
alias src='source ./env/bin/activate'

# Environment variables
export PATH=$PATH:/usr/local/go/bin
export VSCODE_FORWARD="http://localhost:3000"
export PATH=$PATH:$HOME/go/bin
export PATH="$HOME/.composer/vendor/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# cache act nektos/act - cache github actions for local development
export ACT_CACHE_AUTH_KEY=foo

# FZF key bindings and fuzzy completion
source <(fzf --zsh)

# Powerlevel10k theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey '^j' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History settings
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Completion settings
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Custom kill programs
alias kp="ps aux | fzf | awk '{print \$2}' | xargs kill -9"
export PATH=$HOME/bin:$PATH
export VSCODE_FORWARD=http://localhost:3000
