source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug 'denysdovhan/spaceship-prompt', use:'spaceship.zsh', from:github, as:theme

zplug "modules/archive", from:prezto
zplug "plugins/archlinux", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "spwhitt/nix-zsh-completions", from:github
zplug "zsh-users/zsh-autosuggestions", from:github
zplug "zsh-users/zsh-completions", from:github
zplug "zsh-users/zsh-syntax-highlighting", from:github

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose


# ===== History
setopt append_history # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history # save timestamp of command and duration
setopt inc_append_history # Add comamnds as they are typed, don't wait until shell exit
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups # When searching history don't display results already cycled through twice
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
setopt hist_verify # don't execute, just expand history
setopt share_history # imports new commands and appends typed commands to history
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history


export ANDROID_HOME="~/dev/android-sdk"
export PATH="~/.local/bin/:$PATH"
export PATH="~/.cargo/bin/:$PATH"
export PATH="~/.gem/ruby/2.3.0/bin:$PATH"
export PATH="~/go/bin:$PATH"

export PATH="~/.npm-packages/bin/:$PATH"
export NPM_PACKAGES=~/.npm-packages
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
else
   export EDITOR='nvim'
   export SUDO_EDITOR='nvim'
fi
alias vim=nvim

alias ls="ls --color=auto"

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# NIX
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

eval "$(direnv hook zsh)"
