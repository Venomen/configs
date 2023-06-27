# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# zshrc  - ZSH Configuration file
# Author - Dawid Węgliński <cla@gentoo.org>
# Credits - Some of this functions comes from zshwiki, some from .zshrc files
# i've found over the net. Also thanks for welp <welp at gentoo.org>, which from
# i've stollen url-quote-magic and ewho with ecd functions, which were stolen
# from ciaranm <ciaranm at ciaranm.org> ;)
# date - 24.07.2007

# Modifications for OSX and few customs - Dawid Deręgowski <deregowski.net> 
ZSH_CACHE_DIR=${HOME}/.zsh/cache
fpath=(~/.zsh/completion $fpath)

export BW_SESSION="your_BW_SESSION_here"
export ECHANGELOG_USER="Dawid Deręgowski <deregowski.net>"

# Prompt colors
local RED=$'%{\e[0;31m%}'
local GREEN=$'%{\e[0;32m%}'
local YELLOW='%{\e[0;33m%}'
local BLUE=$'%{\e[0;34m%}'
local PINK=$'%{\e[0;35m%}'
local CYAN=$'%{\e[0;36m%}'
local GREY=$'%{\e[1;30m%}'
local NORMAL=$'%{\e[0m%}'

# completion
autoload -U compinit promptinit tetris zcalc url-quote-magic colors edit-command-line

compinit
colors

#compdef _pkglist ecd

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

zle '-N' tetris
zle '-N' url-quote-magic
zle '-N' edit-command-line

bindkey '^X^e' edit-command-line
bindkey '^T' tetris
bindkey "\e^?" backward-delete-word
export WORDCHARS='*?_[]~\!#$%^<>|`@#$%^*()+?'

setopt notify correct
setopt correctall autocd
setopt short_loops
setopt nohup
setopt extended_history
setopt extendedglob
setopt interactivecomments
setopt hist_ignore_all_dups
setopt auto_remove_slash
setopt short_loops


typeset -A abbreviations
abbreviations=(
  "Im"    "| more"
  "Ia"    "| awk"
  "Ig"    "| grep"
  "Ieg"   "| egrep"
  "Ip"    "| $PAGER"
  "Ih"    "| head"
  "It"    "| tail"
  "Is"    "| sort"
  "Iw"    "| wc"
  "Ix"    "| xargs"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

#exporting prompt
if [[ ${UID} == "0" ]]; then
        promptinit
        #prompt gentoo
  export PS1="$(print "${NORMAL}[${GREEN}%M${NORMAL}][${YELLOW}%~${NORMAL}]${RED} %(!.#.$) ${NORMAL}")"
else
        if [[ ${HOST} == "sapphire" ]]; then
                #export PS1="$(print "${GREY}[${YELLOW}%~${GREY}]${YELLOW} %(!.#.$) ${NORMAL}")"
                #export PS1="$(print "${BLUE}[${GREEN}%~${BLUE}]${GREEN} %(!.#.$) ${NORMAL}")"
                #export PS1="$(print "${YELLOW}[${RED}%~${YELLOW}]${RED} %(!.#.$) ${NORMAL}")"
                #export PS1="$(print "${NORMAL}[${RED}%M${NORMAL}][${YELLOW}%~${NORMAL}]${GREEN} %(!.#.$) ${NORMAL}")"
                export PS1="$(print "[${YELLOW}%~${NORMAL}]${GREEN} %(!.#.$) ${NORMAL}")"
        else
                export PS1="$(print "${GREY}[${YELLOW}%M${GREY}][${YELLOW}%~${GREY}]${YELLOW} %(!.#.$) ${NORMAL}")"
        fi
fi

#exporting colors
export GREP_COLOR=31

#aliases
alias less='less +F'
alias ls='ls -G'
#-color=auto' --classify $*'
alias grep='grep --color=auto'

#global aliases
alias -g '...'='../..'
alias -g '....'='../../..'
alias -g M="| more"
alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep"

# some variables for openssh
users=(cla root ircdwww claudiush clsh odysei)
zstyle ':completion:*' users $users

if [[ -f ~/.ssh/known_hosts ]]; then
        _myhosts=(${${${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*}#\[}/]:*/})
        zstyle ':completion:*' hosts $_myhosts
fi

#colors
if [[ -f ~/.dir_colors ]]; then
            eval `dircolors -b ~/.dir_colors`
else
        if [[ -f /etc/DIR_COLORS ]]; then
            eval `dircolors -b /etc/DIR_COLORS`
        fi
fi

umask 022
watch=all
logcheck=30
WATCHFMT="User %n has %a on tty %l at %T %W"

# Display path in titlebar of terms.
[[ -t 1 ]] || return
        case $TERM in
                *xterm*|*rxvt*|(dt|k|E)term)
                precmd() {
                        print -Pn "\e]2;[%n] : [%m] : [%~]\a"
                    }
                preexec() {
                    print -Pn "\e]2;[%n] : [%m] : [%~] : [ $1 ]\a"
                }
        ;;
        esac

# History
export HISTSIZE=5000
export HISTFILE=~/.history_zsh
export SAVEHIST=4000

# of course
export EDITOR="/usr/bin/vim"

# Key Bindings
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

case $TERM in (xterm*)
            bindkey "\e[H" beginning-of-line
            bindkey "\e[F" end-of-line
esac
bindkey "\e[3~" delete-char

# Create a shot of screen an place it in proper directory
shot() {
        [[ ! -d ~/shots ]] && mkdir ~/shots
        cd ~/shots
        [[ -z "$1" ]] && echo "Failed with no argument!" && return
        scrot -cd 5 $(date +%Y_%m_%d_%H-%M)-$1.png
}

# List only file that are images
limg() {
        local -a images
        images=( *.{jpg,jpeg,gif,png,JPG,JPEG,GIF,PNG}(.N) )
        if [[ $#images -eq 0 ]] ; then
                print "No image files found."
        else
                ls "$@" "$images[@]"
        fi
}

status() {
        echo "Date..: $(date "+%Y-%m-%d %H:%M:%S")"
        echo "Shell.: Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
        echo "Term..: $TTY ($TERM), $BAUD bauds, $COLUMNS x $LINES cars"
        echo "Login.: $LOGNAME (UID = $EUID) on $HOST"
        echo "System: $(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
        echo "Uptime:$(uptime)"
}


# Create an index with thumbs. You will need media-gfx/imagemagick to make this
# script working.
genthumbs () {
        rm -rf thumb-* index.html
        echo "
<html>
  <head>
        <title>Images</title>
  </head>
  <body>" > index.html
        for f in *.(gif|jpeg|jpg|png)
        do
            convert -size 100x200 "$f" -resize 100x200 thumb-"$f"
            echo "    <a href=\"$f\"><img src=\"thumb-$f\"></a>" >> index.html
        done
        echo "
  </body>
</html>" >> index.html
}

# Make html file from plain/text
2html() {
        vim -n -c ':so $VIMRUNTIME/syntax/2html.vim' -c ':wqa' $1 > /dev/null 2> /dev/null
}

# Files with space in the name are evil!!!!!!!!
space_rm() {
        for file in *; do
                mv ${file} ${file:gs/\ /_/}
        done
}

# Files with [:upper:] characters in the name are evil as well!
lowercase_mv() {
        for file in *; do
                mv ${file} ${file//(#m)[A-Z]/${(L)MATCH}}
        done
}

# DIE SATANA!
die() {
        echo $1
        return 0
}

#show me the TODO file
#[ -e ~/TODO ] && < ~/TODO

# Speciall thanks for welp, however it's ciaranm's function as far as i know.
# This inspired me to write next function that is below. Moreover, i've
# modernized ecd, so now it shows available versions in the tree. Green color
# means that you don't have this version installed. Red one, with two asterisks
# means that this version is installed in your system

ecd() {
        local pc d file has

        pc=$(efind $*)
        d=$(eportdir)

        if [[ $pc == "" ]] ; then
         echo "nothing found for $*"
         return 1
        fi

        cd ${d}/${pc}
        if [[ -n "$1" ]]; then

        index=1
        for file in *.ebuild; do
                has="0"
                if [[ -d /var/db/pkg/${pc%/*}/${file%.ebuild} ]]; then
                           has="1"
                fi
                if [[ "${has}" == "1" ]]; then
                        print "   [$fg[red]*${index}*$fg[default]]     ${file%.ebuild}"
                else
                        print "   [$fg[green] ${index} $fg[default]]     ${file%.ebuild}"
                fi
                ((index++))
        done
        fi

}

efind() {
        local efinddir cat pkg
        efinddir=$(eportdir)

        case $1 in
            *-*/*)
            pkg=${1##*/}
            cat=${1%/*}
            ;;

            ?*)
            pkg=${1}
            cat=$(echo1 ${efinddir}/*-*/${pkg}/*.ebuild)
            [[ -f $cat ]] || cat=$(echo1 ${efinddir}/*-*/${pkg}*/*.ebuild)
            [[ -f $cat ]] || cat=$(echo1 ${efinddir}/*-*/*${pkg}/*.ebuild)
            [[ -f $cat ]] || cat=$(echo1 ${efinddir}/*-*/*${pkg}*/*.ebuild)
            if [[ ! -f $cat ]]; then
                return 1
            fi
            pkg=${cat%/*}
            pkg=${pkg##*/}
            cat=${cat#${efinddir}/}
            cat=${cat%%/*}
            ;;
        esac

        echo ${cat}/${pkg}
}

echo1() {
        echo "$1"
}

updaterc() {
        wget https://yourupdatehosthere.com/.zshrc.mac -O ~/.zshrc
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export TERM=xterm-256color

# Using pinentry from brew
export GPG_AGENT_CHECK=$(pgrep gpg-agent)

if [ -n "$GPG_AGENT_CHECK" ]; then
  echo "Ok, gpg-agent found." ;
else
  echo "No running gpg-agent found. Starting gpg-agent..."
  eval $(gpg-agent -q --daemon --log-file=${HOME}/.gnupg/gpg-agent.log --default-cache-ttl=28800 --pinentry-program=/opt/homebrew/bin/pinentry)
  echo "Agent pid $(pgrep gpg-agent)"
fi

# Discover the running ssh-agent or start it
# (OSX only: remove com.openssh.ssh-agent from launchctl!)
# Using ssh-agent from brew
export SSH_AGENT_CHECK=$(ps aux | grep /opt/homebrew/bin/ssh-agent | grep -v color | awk {'print $2'})

if [ -n "$SSH_AGENT_CHECK" ]; then
  echo "Ok, ssh-agent found." ;
  export SSH_AGENT_PID=$(ps aux | grep /opt/homebrew/bin/ssh-agent | grep -v color | awk {'print $2'})
  export SSH_AUTH_SOCK=$(cat ${HOME}/.ssh-auth-sock)
else
  echo "No running ssh-agent found. Starting ssh-agent..."
  eval $(/opt/homebrew/bin/ssh-agent)
  /opt/homebrew/bin/ssh-add -t 28800
  echo "$SSH_AUTH_SOCK" > ${HOME}/.ssh-auth-sock
  echo "$SSH_AGENT_PID" > ${HOME}/.ssh-agent-pid
fi

alias lc='colorls -r'

alias kns='/opt/homebrew/bin/kubens'

alias kctx='/opt/homebrew/bin/kubectx'

[[ -n "$SSH_CLIENT" ]] || export DEFAULT_USER="${USER}"

POWERLEVEL9K_MODE='nerdfont-complete'
#POWERLEVEL9K_MODE='awesome-fontconfig'
#POWERLEVEL9K_MODE='awesome-patched'

#ZSH_THEME="powerlevel9k/powerlevel9k"

source /opt/homebrew/opt/powerlevel9k/powerlevel9k.zsh-theme

source /opt/homebrew/share/antigen/antigen.zsh

source ~/.zsh/custom/plugins/kubectl.plugin.zsh

antigen bundle desyncr/auto-ls

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
#antigen bundle unixorn/docker-helpers.zshplugin
antigen bundle webyneter/docker-aliases.git
antigen bundle docker-compose
antigen bundle kubectl
antigen bundle docker

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell

antigen apply

plugins=(tmux docker docker-aliases docker-helpers docker-compose git kube-ps1 kubectl)

KUBE_PS1_COLOR_CONTEXT="%{$FG[037]%}"
KUBE_PS1_COLOR_NS="%{$FG[142]%}"

PROMPT=$PROMPT'$(kube_ps1) '

function check_ip () {
  ip=$1; revdns=$(dig +short -x "$ip"); dns_a=$(dig +short A "$revdns"); echo -e -n "RevDNS: $revdns\nA: $dns_a\nStatus: "; [[ "$ip" == "$dns_a" ]] && echo "OK" || echo "FAIL" 
}

GOBIN="/usr/local/go/bin/"
export GOBIN
GOPATH="${HOME}/go/"
export GOPATH
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH="/usr/local/sbin:$PATH"
export ANSIBLE_INVENTORY=~/ansible_hosts

alias ping='prettyping --nolegend'

alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"

alias help='tldr'

alias k='kubectl'

alias windows='lwsm restore 2screen'

alias t='/opt/homebrew/bin/terraform'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# save live to history & share it
setopt inc_append_history
setopt share_history

compdef _kubectl k

##complete -F __start_kubectl k

if [ -f '/etc/bash_completion.d/azure-cli' ]; then . '/etc/bash_completion.d/azure-cli'; fi

if [ -f '/usr/local/bin/aws_completer' ]; then complete -C aws_completer aws; fi

source <(kubectl completion zsh)
#source <(kubectl completion zsh  | grep -v '^autoload .*compinit$')


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Convert video to gif file.
# Usage: video2gif video_file (scale) (fps)
video2gif() {
  ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
  ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
  rm "${1}.png"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="/opt/homebrew/opt/node@14/bin:$PATH"

#compdef _dagger dagger

# zsh completion for dagger                               -*- shell-script -*-

__dagger_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_dagger()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace
    local -a completions

    __dagger_debug "\n========= starting completion logic =========="
    __dagger_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __dagger_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __dagger_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., dagger -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __dagger_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __dagger_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __dagger_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __dagger_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __dagger_debug "No directive found.  Setting do default"
        directive=0
    fi

    __dagger_debug "directive: ${directive}"
    __dagger_debug "completions: ${out}"
    __dagger_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __dagger_debug "Completion received error. Ignoring completions."
        return
    fi

    while IFS='\n' read -r comp; do
        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab=$(printf '\t')
            comp=${comp//$tab/:}

            __dagger_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __dagger_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __dagger_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subDir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __dagger_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __dagger_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __dagger_debug "Calling _describe"
        if eval _describe "completions" completions $flagPrefix $noSpace; then
            __dagger_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __dagger_debug "_describe did not find completions."
            __dagger_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __dagger_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __dagger_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_dagger" ]; then
	_dagger
fi

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

alias z="source ~/.zshrc"
alias v="vim"
alias awsp="source _awsp"

function aws_prof {
  local profile="${AWS_PROFILE:=default}"

  echo "%{$fg_bold[blue]%}aws:(%{$fg[yellow]%}${profile}%{$fg_bold[blue]%})%{$reset_color%} "
}

PROMPT2='OTHER_PROMPT_STUFF $(aws_prof)'

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/node@16/lib"
export CPPFLAGS="-I/opt/homebrew/opt/node@16/include"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
