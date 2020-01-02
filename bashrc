# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
## This file is sourced by all *interactive* bash shells on startup.  This
## file *should generate no output* or it will break the scp and rcp commands.
############################################################

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -e /etc/bashrc ] ; then
  . /etc/bashrc
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

############################################################
## PATH
############################################################

if [ -d ~/bin ] ; then
  PATH="~/bin:${PATH}"
fi

if [ -d /usr/local/bin ] ; then
  PATH="/usr/local/bin:${PATH}"
fi

if [ -d /usr/local/sbin ] ; then
  PATH="${PATH}:/usr/local/sbin"
fi

# rbenv
if [ `which rbenv 2> /dev/null` ]; then
  eval "$(rbenv init -)"
fi

# Node Package Manager
if [ -d /usr/local/share/npm/bin ] ; then
  NODE_PATH="/usr/local/lib/node"
  PATH="${PATH}:/usr/local/share/npm/bin"
fi

# MySql
if [ -d /usr/local/mysql/bin ] ; then
  PATH="${PATH}:/usr/local/mysql/bin"
fi

# PostgreSQL
if [ -d /opt/local/lib/postgresql83/bin ] ; then
  PATH="${PATH}:/opt/local/lib/postgresql83/bin"
fi

PATH=./bin:${PATH}
PATH=.:${PATH}

############################################################
## MANPATH
############################################################

if [ -d /usr/local/man ] ; then
  MANPATH="/usr/local/man:${MANPATH}"
fi

############################################################
## RVM
############################################################

# if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

############################################################
## Terminal behavior
############################################################

# Change the window title of X terminals
case $TERM in
  xterm*|rxvt|Eterm|eterm)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
    ;;
  screen)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
    ;;
esac

# Show the git branch and dirty state in the prompt.
# Borrowed from: http://henrik.nyh.se/2008/12/git-dirty-prompt
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\(\1$(parse_git_dirty)\)/"
}

if [ `which git` ]; then
  function git_prompt {
    parse_git_branch
  }
else
  function git_prompt {
    echo ""
  }
fi

if [ `which rvm-prompt` ]; then
  function rvm_prompt {
    echo "($(rvm-prompt v g))"
  }
else
  function rvm_prompt {
    echo ""
  }
fi

# Do not set PS1 for dumb terminals
if [ "$TERM" != 'dumb' ] && [ -n "$BASH" ]; then
  # export PS1='\[\033[32m\]\n[\s: \w] $(rvm_prompt) $(git_prompt)\n\[\033[31m\][\u@\h]\$ \[\033[00m\]'
  export PS1='\[\033[32m\]\n[\s: \w] $(git_prompt)\n\[\033[31m\][\u@\h]\$ \[\033[00m\]'
fi

############################################################
## Optional shell behavior
############################################################

shopt -s cdspell
shopt -s extglob
shopt -s checkwinsize

export PAGER="less"
export EDITOR="vim"

############################################################
## History
############################################################

# When you exit a shell, the history from that session is appended to
# ~/.bash_history.  Without this, you might very well lose the history of entire
# sessions (weird that this is not enabled by default).
shopt -s histappend

export HISTIGNORE="&:pwd:ls:ll:lal:[bf]g:exit:rm*:sudo rm*"
# remove duplicates from the history (when a new item is added)
export HISTCONTROL=erasedups
# increase the default size from only 1,000 items
export HISTSIZE=10000

############################################################
## Bash Completion, if available
############################################################

if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
elif  [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif  [ -f /etc/profile.d/bash_completion ]; then
  . /etc/profile.d/bash_completion
fi

# http://onrails.org/articles/2006/11/17/rake-command-completion-using-rake
if [ -f ~/bin/rake_completion ]; then
  complete -C ~/bin/rake_completion -o default rake
fi

if [ -f ~/bin/thor_completion ]; then
  . ~/bin/thor_completion
fi

if [ -f ~/bin/git_completion ]; then
  . ~/bin/git_completion
fi

function _ssh_completion() {
  perl -ne 'print "$1 " if /^Host (.+)$/' ~/.ssh/config
}
complete -W "$(_ssh_completion)" ssh

# if [ -f ~/.rbenv/completions/rbenv.bash ]; then
#   . ~/.rbenv/completions/rbenv.bash
# fi

############################################################
## Other
############################################################

source /usr/local/etc/bash_completion.d/cdargs-bash.sh

if [[ "$USER" == '' ]]; then
  # mainly for cygwin terminals. set USER env var if not already set
  USER=$USERNAME
fi

############################################################
## Aliases
############################################################

if [ -e ~/.bash_aliases ] ; then
  . ~/.bash_aliases
fi

############################################################

set -o emacs

function git_remote_branch_report {
  if [ $1 ]; then
    for k in `git branch -r | sed "s/ ->.*//"`;do echo -e `git log -1 --pretty=format:"%Cgreen%ci^%Cblue%cr^%Cred%an^%Creset^" "$k"`\\t"$k";done | sort -r | grep -i $1 | column -t -s^
  else
    for k in `git branch -r | sed "s/ ->.*//"`;do echo -e `git log -1 --pretty=format:"%Cgreen%ci^%Cblue%cr^%Cred%an^%Creset^" "$k"`\\t"$k";done | sort -r | column -t -s^
  fi
}

function git_remote_branch_kill_by_author {
  if [ $1 ]; then
    read -r -d '' RUBY <<-'EOS'
      $remove_remaining = false
      $commands = []

      def remove(remote_ref)
        $commands << "git push origin :#{remote_ref}"
      end

      puts "Reading branches for #{ARGV[0]}..."
      lines = %x(for k in `git branch -r | sed "s/ ->.*//"`; do echo `git log -1 --pretty=format:"%Cgreen%ci^%Cblue%cr^%Cred%an^%Creset^" "$k"` "$k"; done | sort -r | grep -i #{ARGV[0]}).split("\n")
      puts "Got #{lines.size} refs.\n"

      lines.each do |l|
        parts = l.split(/\s*\^\s*/)
        remote_ref = parts[-1].gsub(/origin\//, '')
        print parts.join("  ")
        if $remove_remaining
          puts
          remove remote_ref
        else
          print "   Remove? (y/n/a): "
          input = STDIN.gets.chomp
          if input == "a"
            puts "Removing remaining!"
            $remove_remaining = true
            remove(remote_ref)
          elsif input == "y"
            remove(remote_ref)
          end
        end
      end

      puts "Please wait while the branches are deleted..."
      $commands.each { |c| puts c; system(c) }
      puts "Done."
EOS
    echo "$RUBY" > /tmp/_grbkba.rb
    ruby /tmp/_grbkba.rb $1
  else
    echo Must provide name of author to grep on.
  fi
}

function pairwith {
  if [ $1 ]; then
    if [ $1 == "self" ]; then
      unset GIT_AUTHOR_NAME
      echo Pairing with self... ಠ_ಠ
    else
      export GIT_AUTHOR_NAME="${1} & Garvin"
      echo $1 > ~/.last_pairwith
      echo Committing as ${GIT_AUTHOR_NAME}
    fi
  else
    other=$(cat ~/.last_pairwith)
    export GIT_AUTHOR_NAME="${other} & Garvin"
    echo Committing as ${GIT_AUTHOR_NAME}
  fi
}

export GOPATH=$HOME/go

function _update_ps1() {
  PS1="$($GOPATH/bin/powerline-go -modules aws,kube,venv,git,cwd -error $?)"
}

if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
