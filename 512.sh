#!/usr/bin/env bash

CURRENT_DIR="$(pwd)"

function get_rnd() {
	local rnd=$1
	echo "$(($RANDOM % $rnd + 1))"
}

function get_rnd_integer(){
	echo "$(($RANDOM % 5 == 0 ? 4 : 2))"
}

function init_matrix(){
	gsed -E -u -e "
		s/-/$(get_rnd_integer)/$(get_rnd 16)
		s/-/$(get_rnd_integer)/$(get_rnd 15)
		y/24/ab/
    " <<< "&----&----&----&----"
}

function controls(){
	echo "$(init_matrix)"

	while true
	do
		read -s -n 1 btn
		case "${btn}" in
			k) direction=U;;
			j) direction=D;;
			l) direction=R;;	
			h) direction=L;;
			*) direction=;;
		esac

		if [ -n "${direction}" ]
		then
			echo "${direction} $(get_rnd 16);$(get_rnd_integer)"
		fi
	done
}


function _2048(){
	gsed -Enuf "${CURRENT_DIR}/512.sed"
}

function colorize(){
	txtblk='\[0;30m' # Black - Regular
	txtred='\[0;31m' # Red
	txtgrn='\[0;32m' # Green
	txtylw='\[0;33m' # Yellow
	txtblu='\[0;34m' # Blue
	txtpur='\[0;35m' # Purple
	txtcyn='\[0;36m' # Cyan
	txtwht='\[0;37m' # White
	bldblk='\[1;30m' # Black - Bold
	bldred='\[1;31m' # Red
	bldgrn='\[1;32m' # Green
	bldylw='\[1;33m' # Yellow
	bldblu='\[1;34m' # Blue
	bldpur='\[1;35m' # Purple
	bldcyn='\[1;36m' # Cyan
	bldwht='\[1;37m' # White
	unkblk='\[4;30m' # Black - Underline
	undred='\[4;31m' # Red
	undgrn='\[4;32m' # Green
	undylw='\[4;33m' # Yellow
	undblu='\[4;34m' # Blue
	undpur='\[4;35m' # Purple
	undcyn='\[4;36m' # Cyan
	undwht='\[4;37m' # White
	bakblk='\[40m'   # Black - Background
	bakred='\[41m'   # Red
	bakgrn='\[42m'   # Green
	bakylw='\[43m'   # Yellow
	bakblu='\[44m'   # Blue
	bakpur='\[45m'   # Purple
	bakcyn='\[46m'   # Cyan
	bakwht='\[47m'   # White
	txtrst='\[0m'    # Text Reset
	gsed "s/__4_/${bakylw}__4_${txtrst}/g
	s/__8_/${bldylw}__8_${txtrst}/g
	s/__16/${bakpur}__16${txtrst}/g
	s/__32/${bldpur}__32${txtrst}/g
	s/__64/${bakgrn}__64${txtrst}/g
	s/_128/${bldgrn}_128${txtrst}/g
	s/_256/${bakcyn}_256${txtrst}/g
	s/_512/${bldcyn}_512${txtrst}/g
	s/1024/${bakred}1024${txtrst}/g
	s/2048/${bldred}2048${txtrst}/g
	s/4096/${bakgrn}4096${txtrst}/g"
}
echo "To move blocks use hjkl"
echo "Enjoy!"
controls | _2048 | colorize


