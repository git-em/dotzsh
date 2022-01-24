# my first zshrc 0.1.3
# created 2021-08-20
# last edit 2022-01-24


pfetch
#cfonts "welcome" -f 3d --align center -c cyan,magenta



source ~/.fzf.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$HOME/.config/aliasrc"


export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export EDITOR="nvim"

PRAATH="/Applications/Praat.app/Contents/MacOS/Praat"
PROMPT="%B%F{160}%~%f%b %F{yellow}$%f "
RPROMPT=""
KEYTIMEOUT=1
HISTSIZE=100000000
SAVEHIST=100000000
HISTFILE=~/.cache/zsh/history

ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=238'


FZF_DEFAULT_COMMAND="fd --type f --hidden --no-ignore --exclude '/Users/teste/Library/Container/*' --exclude '/Users/teste/.Trash/*' --exclude '/.Trash'"
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_ALT_C_COMMAND="fd --type d --hidden --no-ignore --exclude '/Users/teste/Library/Container/*' --exclude '/Users/teste/.Trash/*' --exclude '/.Trash'"
FZF_COMPLETION_TRIGGER='ff'



autoload -Uz edit-command-line; zle -N edit-command-line # Allow command line editing with <c-e> in an external editor with: bindkey '^e' edit-command-line
autoload -U colors && colors                            # enable colors and change prompt (?)
autoload -Uz compinit; compinit                         # autocomplete
_comp_options+=(globdots)                               # include hidden files
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case insentive




setopt EXTENDED_HISTORY     # Write the history file in the ':start:elapsed;command' format.
setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
#setopt HIST_VERIFY    # Do not execute immediately upon history expansion.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.

#setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.
setopt PATH_DIRS            # Perform path search even on command names with slashes.
setopt AUTO_MENU            # Show completion menu on a successive tab press.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
#setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE      # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL       # Disable start/stop characters in shell editor.

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
#unsetopt CLOBBER            # Do not overwrite existing files with > and >> - Use >! and >>! to bypass.




bindkey -v      # vi mode
bindkey -v '^?' backward-delete-char    # permite backspace depois de editar com A no vimode
bindkey -a "^[[3~" delete-char
bindkey '^n' fzf-cd-widget              # aparentemente esses widgets só funcionam com atalhos do teclado (ou seja quando o zle está ativo ativo) ver man zshzle




alias d='dirs -v' # print and jump dirs
for index ({1..9}) alias "$index"="cd +${index}"; unset index # type index to go


function soma(){
    tmux new-window -n "somafm" somafm listen $(somafm list | fzf | awk '{print $1}') && tmux select-window -l && echo -e "\n Music mode: engaged! \n"
}

function rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}
