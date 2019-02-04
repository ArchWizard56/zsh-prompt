#!/bin/zsh

setopt prompt_subst
function git_custom_status {
	git status --short &> /dev/null
	if [ $? -eq 0 ]
	then
		if [ -z `git status --short | awk '{print $1}' |head -n 1` ]
		then
		DIFF=""
	else
		DIFF=" x"
fi
        if [ $NOCOLORS!="TRUE" ] 
        then
		echo "%{$fg[yellow]%}($(git status -b --short | sed 's/## //g' |awk -F. '{print $1}' | head -n 1)$DIFF)%{$reset_color%}"
        else
		echo "($(git status -b --short | sed 's/## //g' |awk -F. '{print $1}' | head -n 1)$DIFF)"
fi

        
	fi
}
function zle-line-init zle-keymap-select {
        if [ $NOCOLORS!="TRUE" ] 
        then
    return_code="%(?..%{$fg[red]%})"
    VIM_PROMPT="%{$fg[white]%} [% NORMAL]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $(git_custom_status) $EPS1"
    PROMPT="%{$fg[blue]%}%m%{$fg[white]%}::%{$fg[cyan]%}%~%{$fg[green]%}${return_code} %#> %{$reset_color%}"
else
    VIM_PROMPT="[% NORMAL]% "
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $(git_custom_status) $EPS1"
    PROMPT="%m::%~ %#> "

fi
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

