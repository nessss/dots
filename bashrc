# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   	return
fi

# Make bash check its window size after a process completes
shopt -s checkwinsize
# Tell the terminal about the working directory at each prompt.
if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL,
        # including the host name to disambiguate local vs.
        # remote connections. Percent-escape spaces.
		local SEARCH=' '
		local REPLACE='%20'
		local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
		printf '\e]7;%s\a' "$PWD_URL"
    }
    PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
fi

alias debug='set -o nounset; set -o xtrace'
alias mv='mv -iv'
alias cp='cp -iv'
alias mkdir='mkdir -p'

alias readlink='greadlink'

alias path='echo -e ${PATH//:/\\n}'

alias du='du -kh'

set -o notify
set -o noclobber
set -o ignoreeof
set -o vi

if [ -d ~/.bash ]; then
    source ~/.bash/ls
    source ~/.bash/less
    source ~/.bash/git-completion
fi

shopt -s cdspell
shopt -s cdable_vars
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob

exitstatus(){
    if [[ $? == 0 ]]; then
        echo '😸'
    else
        echo '🙀'
    fi
}

PS1='\W $(exitstatus)  '

PATH=/usr/bin:/bin:/usr/local/bin:/usr/games/bin:usr/local/lib:usr/lib:$PATH

alias edit_karabiner="vim $HOME/Library/Application\ Support/Karabiner/private.xml"

alias chuck_loop="chuck --loop --caution-to-the-wind 2>& /dev/ttys003 1>&/dev/ttys002"

if command -v tmux>/dev/null; then
    [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
fi

true

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
