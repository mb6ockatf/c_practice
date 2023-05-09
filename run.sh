#!/usr/bin/env bash
# prepare source files & compile

readonly END="\033[0m"
readonly BLACK="\033[0;30m"
readonly BLACKB="\033[1;30m"
readonly WHITE="\033[0;37m"
readonly WHITEB="\033[1;37m"
readonly RED="\033[0;31m"
readonly REDB="\033[1;31m"
readonly GREEN="\033[0;32m"
readonly GREENB="\033[1;32m"
readonly YELLOW="\033[0;33m"
readonly YELLOWB="\033[1;33m"
readonly BLUE="\033[0;34m"
readonly BLUEB="\033[1;34m"
readonly PURPLE="\033[0;35m"
readonly PURPLEB="\033[1;35m"
readonly LIGHTBLUE="\033[0;36m"
readonly LIGHTBLUEB="\033[1;36m"

###############################################################################
# format $2 message so it is $1 color
# arguments: []
# output: colorful message
# return: 2 if wrong color
###############################################################################
color::form_output() {
	if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]] || [[ -z "$1" ]]; then
		name="color::form_output"
		echo -e "apply color to any text"
		echo -e "USAGE"
		echo -e "- show this message (default)"
		echo -e "\t $name [-h, --help]"
		echo -e "- get colored message"
		echo -e "\t $name color message"
		repeat_char - 80
		echo "by @mb6ockatf, Mon 08 May 2023 09:05:30 PM MSK"
		return 0
	fi
	local color="$1" message="$2"
	case "$color" in
		black)      color="${BLACK}"      ;;
		blackb)     color="${BLACKB}"     ;;
		white)      color="${WHITE}"      ;;
		whiteb)     color="${WHITEB}"     ;;
		red)        color="${RED}"        ;;
		redb)       color="${REDB}"       ;;
		green)      color="${GREEN}"      ;;
		greenb)     color="${GREENB}"     ;;
		yellow)     color="${YELLOW}"     ;;
		yellowb)    color="${YELLOWB}"    ;;
		blue)       color="${BLUE}"       ;;
		blueb)      color="${BLUEB}"      ;;
		purple)     color="${PURPLE}"     ;;
		purpleb)    color="${PURPLEB}"    ;;
		lightblue)  color="${LIGHTBLUE}"  ;;
		lightblueb) color="${LIGHTBLUEB}" ;;
		*)          return 2              ;;
	esac
	echo -e "${color}${message}${END}"
}

###############################################################################
# return incremented $1 to stdin
# arguments: $1 value for inrementation
# output: inremented $1
###############################################################################
inc() {
	echo $(($1+1));
}

###############################################################################
# repeat character $1 $2 times
# arguments: $1 character, $2 number
# output: $2 characters
###############################################################################
repeat_char() {
	local char="$1"
	local n="$2"
	[ -z "$char" ] && char="-"
	[ -z "$n" ] && n=80
	for (( i = 1; i < "$n"; i++ )); do
		echo -n "$char"
	done
}

###############################################################################
# format message with prefix and max length of 80 characters
# arguments: $1 prefix, $2 message
# output: formatted message
###############################################################################
format_message() {
	echo "$2" | fmt -w 80 -g 80 | xargs -I'{}' echo "$1:" '{}'
}

###############################################################################
# refactor *.c files recirsively in the current folder
# original files are renamed into oldname.orig
# output: formatted c files
###############################################################################
refactor::c() {
	astyle --version &> /dev/null
	if [ "$?" == 127 ]; then
		local message
		message=$(color::form_output red "Please install astyle formatter: ")
		message+=$(color::form_output blue https://astyle.sourceforge.net/)
		echo -e "$message"
		return 127
	else
		astyle -rv \
		--style=linux \
		--indent=force-tab=4 \
		--delete-empty-lines\
		--break-closing-braces \
		--max-code-length=80 \
		--lineend=linux \
		--ascii \
		"*.c"
	fi
}

###############################################################################
# refactor *.sh files recirsively in the current folder
# original files are renamed into oldname.orig
# output: formatted sh files
###############################################################################
refactor::sh(){
	while IFS= read -r -d '' filename; do
		cp "$filename" "${filename}.orig"
		sed -i '/^\s*$/d; /.*\}$/G' "$filename"
	done <	<(find ./ -type f -iname "*.sh")
}

###############################################################################
# print usage help
# output: help prompt
###############################################################################
usage() {
	local name="${BASH_SOURCE[*]}"
	echo -e "refactor source files & compile and run"
	echo -e "USAGE"
	echo -e "- show this message (default)"
	echo -e "\t $name [-h, --help]"
	echo -e "- compile c file and run it"
	echo -e "\t $name file"
	repeat_char - 80
	echo "mb6ockatf, Tue 09 May 2023 02:46:35 PM MSK"
	unset name
}

###############################################################################
# just main function
# arguments: takes all arguments sent to BASH_SOURCE[*]
###############################################################################
main() {
	separator=$(repeat_char "*")
	RUNNING=$(color::form_output green "RUNNING")
	ATTENTION=$(color::form_output yellow "ATTENTION")
	format_message "$RUNNING" "astyle c  files refactoring" && refactor::c
	format_message "$RUNNING" "simple sh files refactoring" && refactor::sh
	echo "$separator"
	format_message "$ATTENTION" "always check your code after it has been styled!"
	echo "$separator"
	format_message "$RUNNING" "moving original files to ./original"
	mkdir -p original
	[ ! -f "*.orig" ] || mv ./*.orig original/
	if [ -n "$1" ]; then
		format_message "$RUNNING" "compiling ${1} with gcc"
		gcc -v -Werror "$1"
		format_message "$RUNNING" "a.out" && ./a.out
	fi
	echo "$separator"
}

case "$1" in
	"--help" | "-h")
		help_message ;;
	*)
		main "$@" ;;
esac
