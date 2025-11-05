# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="spaceship"

SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git gh nvm svn node npm docker github z github jump rust zsh-vi-mode virtualenv kubectl helm zsh-autosuggestions web-search)

source $ZSH/oh-my-zsh.sh


# Load aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

autoload -Uz compinit
compinit

# Completion for kitty
if command -v kitty 2>&1 >/dev/null
then
  kitty + complete setup zsh | source /dev/stdin
fi
fpath=($fpath "~/.zfunctions")
zstyle ':completion:*:*:make:*' tag-order 'targets'

alias ssh='TERM=xterm ssh'

source ~/.profile

# https://www.reddit.com/r/neovim/comments/48ymsn/fzf_how_to_show_hidden_files/
export FZF_DEFAULT_COMMAND="find -L"
command -v kubectl &> /dev/null && source <(kubectl completion zsh)

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end     

# GO 1.20
export GOROOT=/usr/local/go 
export GOPATH=/work/workspaces/workspace-go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH 

# nvim
export PATH=/opt/nvim-linux-x86_64/bin:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
