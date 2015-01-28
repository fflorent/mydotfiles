# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=6000
SAVEHIST=6000
setopt appendhistory autocd extendedglob autopushd pushdignoredups
bindkey -v
if [[ -f $HOME/.profile ]]; then
    source $HOME/.profile;
fi
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/florent/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# <PS1>
	autoload -Uz colors && colors
	autoload -Uz vcs_info
	zstyle ':vcs_info:*' enable git svn
	zstyle ':vcs_info:git*' formats "%{$fg[red]%}%r/%S%%{$reset_color%} %{$fg[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%} "
	setopt promptsubst
	function precmd()
	{
		vcs_info 'prompt'
		PS1=$'%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%} \n %% '
	 	RPS1='${vcs_info_msg_0_}'
	}
# </PS1>

# <binkeys>
	# Control-left / Alt-Left
	bindkey "^[[1;5D" backward-word
	bindkey "^[[1;3D" beginning-of-line
	bindkey "^[[1;5C" forward-word
	bindkey "^[[1;3C" end-of-line
	bindkey '^[[Z' reverse-menu-complete

	# Undo / redo
	bindkey "^[u" undo
	bindkey "^[r" redo
	bindkey '\e.' insert-last-word
	
	# make ALT-BACKSPACE (and other shortcuts) work like in bash
	autoload -U select-word-style
	select-word-style bash

	# Kill words
	bindkey "^w" backward-kill-word

	# vi search-fix
	vi-search-fix() {
		zle vi-cmd-mode
		zle .vi-history-search-backward
	}

	autoload vi-search-fix
	zle -N vi-search-fix
	bindkey -M viins '\e/' vi-search-fix
	
	# ctrl-r starts searching history backward
	bindkey '^r' history-incremental-search-backward

	# Escape
	bindkey -M viins 'jk' vi-cmd-mode # "jk" => escape
	bindkey -M viins 'kj' vi-cmd-mode # "jk" => escape

	# edit-command-line
	autoload -Uz edit-command-line
	zle -N edit-command-line
	bindkey -M vicmd 'v' edit-command-line

# </binkeys>

# <aliases>
	alias ls="ls --color"
	alias ll="ls -l"
	alias la="ls -a"
	alias -s js=vim
	# alias 'vimfb'='vim -u ~/.vimrc_fb'
	alias 'cdFb'='cd ~/javascript/firebug/extension/content/firebug'
	alias 'cdTests'='cd ~/javascript/firebug/tests/content/'
	alias 'cdFBTest'='cd ~/javascript/firebug/tests/FBTest/content'
	alias 'cdTrace'='cd ~/javascript/firebug/trace/FBTrace/'
	alias 'cdfbn'='cd ~/javascript/firebug.next/'
	alias 'vimFBTest'='vim ~/javascript/firebug/tests/FBTest/content/FBTestFirebug.js'
	alias 'vimLoc'='vim ~/javascript/firebug/extension/locale/en-US/firebug.properties';
	alias 'updateTern'='git --git-dir=/home/florent/.vim/bundle/tern_for_vim/.git --work-tree=/home/florent/.vim/bundle/tern_for_vim/ pull; \
		git --git-dir=/home/florent/.vim/bundle/tern_for_vim/node_modules/tern/.git --work-tree=/home/florent/.vim/bundle/tern_for_vim/node_modules/tern/ pull';
	alias 'screencast'="recordmydesktop --windowid \$(xwininfo | awk '/Window id:/ {print \$4}')";
	alias 'screencastAudio'="screencase --channels 1";
	alias 'sourceFb'="cd ~/javascript/addon-sdk/; source bin/activate; cd -;";
	hash -d firebug=/home/florent/javascript/firebug/extension/content/firebug/
	hash -d fbtest=/home/florent/javascript/firebug/tests/FBTest/content/
	hash -d tests=/home/florent/javascript/firebug/tests/content/
# </aliases>

# <completion>
	# caching
	zstyle ':completion:*' use-cache on
	zstyle ':completion:*' cache-path ~/.zsh/cache
	
	# Fuzzy (1-char tolerant)
	zstyle ':completion:*' completer _complete _match _approximate
	zstyle ':completion:*:match:*' original only
	zstyle ':completion:*:approximate:*' max-errors 1 numeric

	# arrow-key driven interface
	zstyle ':completion:*' menu select
	
	# Ignore completion functions for commands you don’t have:
	zstyle ':completion:*:functions' ignored-patterns '_*'

	# Completing process IDs with menu selection
	zstyle ':completion:*:*:kill:*' menu yes select
	zstyle ':completion:*:kill:*'   force-list always	

	# Avoid selecting parent directory in case of ../<TAB>
	zstyle ':completion:*:cd:*' ignore-parents parent pwd

	# Quick change directories. "cd ..." => "cd ../.."; "cd ../..." => "cd ../../.."
	rationalise-dot() {
	  if [[ $LBUFFER = *.. ]]; then
	    LBUFFER+=/..
	  else
	    LBUFFER+=.
	  fi
	}
	zle -N rationalise-dot
	bindkey . rationalise-dot

	# Ignore the case
	setopt no_case_glob
	
# </completion>

export PATH=$PATH:/home/florent/bin
###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _npm_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
