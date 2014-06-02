# Code Directory
CODE=~/code

# language-specific environment vars
export GOPATH=$CODE/go
export GOROOT=/usr/local/go

# Enhance PATH to include /usr/local/bin
export PATH=/usr/local/bin:$PATH
export PATH=~/dev/git-friendly:$PATH # git-friendly
export PATH=$GOPATH/bin:$PATH # add go binaries to path

# Increase history size, ignore duplicates
export HISTCONTROL=ignoreboth
export HISTSIZE=2500
export HISTFILESIZE=2500

# Append to history file, don't overwrite it
shopt -s histappend

# z!!!!

. /usr/local/bin/z.sh

# Check/update windowsize after each command
shopt -s checkwinsize

# TODO: Make less more friendly for non-text input files, see lesspipe(1)
# [ -x /usr/bin/lesspipe.sh ] && export LESSOPEN="|/usr/bin/lesspipe.sh %s"

# Print out which git branch we're currently in
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

# Set the Prompt to be more reasonable
function prompt {
  local BLACK="\[\033[0;30m\]"
  local BLACKBOLD="\[\033[1;30m\]"
  local RED="\[\033[0;31m\]"
  local REDBOLD="\[\033[1;31m\]"
  local GREEN="\[\033[0;32m\]"
  local GREENBOLD="\[\033[1;32m\]"
  local YELLOW="\[\033[0;33m\]"
  local YELLOWBOLD="\[\033[1;33m\]"
  local BLUE="\[\033[0;34m\]"
  local BLUEBOLD="\[\033[1;34m\]"
  local PURPLE="\[\033[0;35m\]"
  local PURPLEBOLD="\[\033[1;35m\]"
  local CYAN="\[\033[0;36m\]"
  local CYANBOLD="\[\033[1;36m\]"
  local WHITE="\[\033[0;37m\]"
  local WHITEBOLD="\[\033[1;37m\]"

  # Set line color, print horizontal line
  PS1="$BLUE"
  PS1+="\$(s=\$(printf "%*s" \$COLUMNS); echo \${s// /-})\n"
  # Reset color
  PS1+="\[\033[0m\]"
  # Old prompt
  PS1+='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1)'
  PS1+="$WHITEBOLD ✗"
  PS1+="\[\033[0m\] "
  export PS1
}
prompt

# Bash Aliases
alias rm='rm -i'
alias ls='ls -G'
alias ll='ls -Gla'
alias grep='grep --color=auto'
alias reup='source ~/.bashrc'

# cd aliases
alias cd..='cd ..'
alias code='cd $CODE'
alias ~='cd ~'

# Vagrant Aliases
alias vhalt='cd $CODE/vagrant-dev-environment && bundle exec vagrant halt'
alias vup='cd $CODE/vagrant-dev-environment && bundle exec vagrant up'
alias vreup='cd $CODE/vagrant-dev-environment && bundle exec vagrant reload'

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

bind "set completion-ignore-case on"

# Easy navigation of file system. This stuff is really good.
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html

export MARKPATH=$HOME/.marks
function jump {
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark {
    rm -i $MARKPATH/$1
}
function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

# GIT THINGS
# Git autocomplete.
if [ ! -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

# Pretty git logs
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"

# Git-oopsicommittedsomethingsensitive, aka git-purge
# Removes a file from the repo and from the history. 
# http://www.ohdoylerules.com/snippets/purge-file-from-github
git-purge() {
  FN="git rm --cached --ignore-unmatch $1"
  git filter-branch --force --index-filter $FN --prune-empty --tag-name-filter cat -- --all
}

clear
echo "Welcome back, Salem."
