source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug 'mafredri/zsh-async', from:github
zplug 'dfurnes/purer', use:pure.zsh, from:github, as:theme

zplug "modules/archive", from:prezto
zplug "plugins/archlinux", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "zsh-users/zsh-completions", from:github
zplug "zsh-users/zsh-syntax-highlighting", from:github
zplug "joel-porquet/zsh-dircolors-solarized", from:github

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load


# ===== History
# Do not write events to history that are duplicates of previous events
setopt HIST_IGNORE_ALL_DUPS
# imports new commands and appends typed commands to history
setopt SHARE_HISTORY
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history

export PATH="/home/nbardiuk/.local/bin/:$PATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
else
   export EDITOR='nvim'
   export SUDO_EDITOR='nvim'
fi
alias vim=nvim

export MANPAGER="nvim +set\ filetype=man -"

alias ls="ls --color=auto"

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /usr/share/undistract-me/long-running.bash
notify_when_long_running_commands_finish_install
