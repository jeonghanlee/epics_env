#!/bin/bash
#
#  Copyright (c) 2016 Jeong Han Lee
#  Copyright (c) 2016 European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#

# Author : Jeong Han Lee
# email  : jeonghan.lee@gmail.com
# Date   : Thursday, December 29 22:55:48 CET 2016
# version : 0.2.1
#
# Generic : Global vaiables - readonly
#
declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME="$(basename "$SC_SCRIPT")"
declare -gr SC_TOP="$(dirname "$SC_SCRIPT")"
declare -gr SC_LOGDATE="$(date +%Y%b%d-%H%M-%S%Z)"


# Generic : Redefine pushd and popd to reduce their output messages
# 
function pushd() { builtin pushd "$@" > /dev/null; }
function popd()  { builtin popd  "$@" > /dev/null; }


function __ini_func() { printf "\n>>>> You are entering in  : %s\n" "${1}"; }
function __end_func() { printf "\n<<<< You are leaving from : %s\n" "${1}"; }

function __checkstr() {
    if [ -z "$1" ]; then
	printf "%s : input variable is not defined \n" "${FUNCNAME[*]}"
	exit 1;
    fi
}

# Generic : git_selection
#
#         only for archappl
#
# Require Global vairable
# - SC_SELECTED_GIT_SRC  : Output
#
function git_selection() {

    local func_name=${FUNCNAME[*]}; __ini_func ${func_name};

    local git_ckoutcmd=""
    local checked_git_src=""

    
    declare -i index=0
    declare -i master_index=0
    declare -i list_size=0
    declare -i selected_one=0
    declare -a git_src_list=()

    
    local n_tags=${1};

    # no set n_tags, set default 10
    
    if [[ ${n_tags} -eq 0 ]]; then
	n_tags=20;
    fi

    git_src_list+=("master")

    git_src_list+=($(git tag -l | sort -V -r | grep -v -e alpha -e beta -e pre -e rc | head -n${n_tags}))
    
    
    git_src_list+=($(git tag -l | xargs -I@ git log --format=format:"%ai @%n" -1 @ | sort -r | head -n${n_tags} | awk '{print $4}'))
    
    for tag in "${git_src_list[@]}"
    do
	printf "%2s: git src %34s\n" "$index" "$tag"
	let "index = $index + 1"
    done

    # type [ENTER], 0 is selected as default.
    echo -n "Select master (0, enter) or one of tags which can be built, followed by [ENTER]: "

    read -e line
   
    # convert a string to an integer?
    # do I need this? 
    # selected_one=${line/.*}

    selected_one=${line}
    
    let "list_size = ${#git_src_list[@]} - 1"
    
    if [[ "$selected_one" -gt "$list_size" ]]; then
	printf "\n>>> Please select one number smaller than %s\n" "${list_size}"
	exit 1;
    fi
    if [[ "$selected_one" -lt 0 ]]; then
	printf "\n>>> Please select one number larger than 0\n" 
	exit 1;
    fi

    SC_SELECTED_GIT_SRC="$(tr -d ' ' <<< ${git_src_list[line]})"
    
    printf "\n>>> Selected %34s --- \n" "${SC_SELECTED_GIT_SRC}"
 
    echo ""
    if [ "$selected_one" -ne "$master_index" ]; then
	git_ckoutcmd="git checkout tags/${SC_SELECTED_GIT_SRC}"
	$git_ckoutcmd
	checked_git_src="$(git describe --exact-match --tags)"
	checked_git_src="$(tr -d ' ' <<< ${checked_git_src})"
	
	printf "\n>>> Selected : %s --- \n>>> Checkout : %s --- \n" "${SC_SELECTED_GIT_SRC}" "${checked_git_src}"
	
	if [ "${SC_SELECTED_GIT_SRC}" != "${checked_git_src}" ]; then
	    echo "Something is not right, please check your git reposiotry"
	    exit 1
	fi
    else
	git_ckoutcmd="git checkout ${SC_SELECTED_GIT_SRC}"
	$git_ckoutcmd
    fi

    git submodule update --init --recursive
    
    __end_func ${func_name}
 
}





# Generic : git_selection
#
# 1.0.3 : Thursday, October  6 15:34:12 CEST 2016
#
# Require Global vairable
# - SC_SELECTED_GIT_SRC  : Output
#
function git_selection() {

    local func_name=${FUNCNAME[*]}; __ini_func ${func_name};

    local git_ckoutcmd=""
    local checked_git_src=""

    
    declare -i index=0
    declare -i master_index=0
    declare -i list_size=0
    declare -i selected_one=0
    declare -a git_src_list=()

    
    local n_tags=${1};

    # no set n_tags, set default 10
    
    if [[ ${n_tags} -eq 0 ]]; then
	n_tags=20;
    fi

    git_src_list+=("master")

    git_src_list+=($(git tag -l | sort -V -r | grep -v -e alpha -e beta -e pre -e rc | head -n${n_tags}))
    
    for tag in "${git_src_list[@]}"
    do
	printf "%2s: git src %34s\n" "$index" "$tag"
	let "index = $index + 1"
    done
    
    echo -n "Select master or one of tags which can be built, followed by [ENTER]:"

    # don't wait for 3 characters 
    # read -e -n 2 line
    read -e line
   
    # convert a string to an integer?
    # do I need this? 
    # selected_one=${line/.*}

    selected_one=${line}
    
    let "list_size = ${#git_src_list[@]} - 1"
    
    if [[ "$selected_one" -gt "$list_size" ]]; then
	printf "\n>>> Please select one number smaller than %s\n" "${list_size}"
	exit 1;
    fi
    if [[ "$selected_one" -lt 0 ]]; then
	printf "\n>>> Please select one number larger than 0\n" 
	exit 1;
    fi

    SC_SELECTED_GIT_SRC="$(tr -d ' ' <<< ${git_src_list[line]})"
    
    printf "\n>>> Selected %34s --- \n" "${SC_SELECTED_GIT_SRC}"
 
    echo ""
    if [ "$selected_one" -ne "$master_index" ]; then
	git_ckoutcmd="git checkout tags/${SC_SELECTED_GIT_SRC}"
	$git_ckoutcmd
	checked_git_src="$(git describe --exact-match --tags)"
	checked_git_src="$(tr -d ' ' <<< ${checked_git_src})"
	
	printf "\n>>> Selected : %s --- \n>>> Checkout : %s --- \n" "${SC_SELECTED_GIT_SRC}" "${checked_git_src}"
	
	if [ "${SC_SELECTED_GIT_SRC}" != "${checked_git_src}" ]; then
	    echo "Something is not right, please check your git reposiotry"
	    exit 1
	fi
    else
	git_ckoutcmd="git checkout ${SC_SELECTED_GIT_SRC}"
	$git_ckoutcmd
    fi

    git submodule update --init --recursive
    
    __end_func ${func_name}
 
}


EPICS_BASE=${SC_TOP}/epics-base
EPICS_MODULES=${SC_TOP}/epics-modules


function select_epics_base(){
    local func_name=${FUNCNAME[*]}; __ini_func ${func_name};
    pushd ${EPICS_BASE}
    git_selection ${tag_cnt};
    popd
    __end_func ${func_name};
}

function select_epics_modules() {
    local func_name=${FUNCNAME[*]}; __ini_func ${func_name};
    pushd ${EPICS_MODULES}
    for amodule in $(find . -mindepth 1 -maxdepth 1 -type d);
    do
	echo ${amodule%%/};
	pushd ${amodule}
	git_selection ${tag_cnt};
	popd
    done
    popd
    __end_func ${func_name};
}  





# What should we do?
DO="$1"
 
case "$DO" in

    all)
	select_epics_base
	select_epics_modules
        ;;
    base)
	select_epics_base
	;;
    modules)
	select_epics_modules
	;;
    *)
	echo "">&2
        echo "usage: $0 <command>" >&2
        echo >&2
        echo "  commands: explaination" >&2
	echo ""
        echo "          all     : Select BASE's and Modules' versions">&2
        echo ""
	echo "          base    : Select BASE's version">&2
	echo ""
	echo "          modules : Select Modules' versions">&2
        echo ""
        echo >&2
	exit 0
        ;;
esac

exit

