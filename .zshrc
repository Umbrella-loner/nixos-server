# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Completion
autoload -Uz compinit
compinit

# Aliases
alias nrs="sudo nixos-rebuild switch"
alias nrb="sudo nixos-rebuild boot"
alias nrt="sudo nixos-rebuild test"
alias nconf="sudo nvim /etc/nixos/configuration.nix"
alias nflake="sudo nvim /etc/nixos/flake.nix"
alias aria="aria2c -x16 -s16"


# Load plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true

# Keybindings
bindkey '^ ' autosuggest-accept

# Path
path+=("$HOME/.local/bin")
export PATH

# Initialize tools

# Prompt
PROMPT='[%n@%m %~] '

