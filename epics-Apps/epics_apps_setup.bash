#!/bin/bash
#
#  Copyright (c) 2016 Jeong Han Lee
#  Copyright (c) 2016 - present European Spallation Source ERIC
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
# Date   : 
# version : 0.1.0 
#
# http://www.gnu.org/software/bash/manual/bashref.html#Bash-Builtins


# 
# PREFIX : SC_, so declare -p can show them in a place
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


function ini_func() { printf "\n>>>> You are entering in : %s\n" "${1}"; }
function end_func() { printf "\n<<<< You are leaving from %s\n" "${1}"; }

function checkstr() {
    if [ -z "$1" ]; then
	printf "%s : input variable is not defined \n" "${FUNCNAME[*]}"
	exit 1;
    fi
}

# Generic : git_clone
#
# Required Global Variable
# - SC_LOGDATE      : Input
# Required Input Variagles
# - ${1} : git source top directory
# - ${2} : git source url
# - ${3} : git source name

function git_clone() {

    local func_name=${FUNCNAME[*]}
    local git_src_top=${1}
    local git_src_url=${2}
    local git_src_name=${3}
    local git_src_dir=${git_src_top}/${git_src_name}
    
    ini_func ${func_name}
    checkstr ${SC_LOGDATE}
       
    if [[ ! -d ${git_src_dir} ]]; then
	echo "No git source repository in the expected location ${git_src_dir}"
	git clone ${git_src_url}/${git_src_name} ${git_src_dir}
    else
	echo "Old git source repository in the expected location ${git_src_dir}"
	echo "Keep the old one, please check them manually"
    fi
    
    end_func ${func_name}
}
# Generic : git_selection
#
# 1.0.3 : Thursday, October  6 15:34:12 CEST 2016
#
# Require Global vairable
# - SC_SELECTED_GIT_SRC  : Output
#
function git_selection() {

    local func_name=${FUNCNAME[*]}; ini_func ${func_name}

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
	n_tags=10;
    fi

    git_src_list+=("master")

    # git_tags=$(git describe --tags `git rev-list --tags --max-count=${n_tags}`);
    # git_exitstatus=$?
    # if [ $git_exitstatus = 0 ]; then
    # 	#
    # 	# (${}) and ($(command))  are important to separate output as an indiviaul arrar
    # 	#
    # 	git_src_list+=(${git_tags});
    # else
    # 	# In case, No tags can describe, use git tag instead of git describe
    # 	#
    # 	# fatal: No tags can describe '7fce903a82d47dec92012664648cacebdacd88e1'.
    # 	# Try --always, or create some tags.
    # doesn't work for CentOS7
    #    git_src_list+=($(git tag -l --sort=-refname  | head -n${n_tags}))
    # fi

    git_src_list+=($(git tag -l | sort -r | head -n${n_tags}))
    
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

    # Without selection number, type [ENTER], 0 is selected as default.
    #
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
    end_func ${func_name}
 
}



function git_select() {

    SRC_NAME=${2}
    #"danfysik-mps8500"
    SRC_URL=${1}
    # "https://github.com/jeonghanlee"
    SRC_DIR=${SC_TOP}/${SC_GIT_SRC_NAME}


    git_clone ${SRC_DIR} ${SRC_URL} ${SRC_NAME}

    pushd ${SRC_DIR}/${SRC_NAME}

    git_selection
    
    if [ -f .gitignore ]; then
	echo ".gitignore exists"
    else
	cat > .gitignore <<EOF
*~
*Common
dbd
include
doc
html
db
adl
alh
cfg
edl
lib
envPaths
#*
*#
.#*
*log.*
bin
O.*
EOF
    fi
    popd   
}

git_select "https://github.com/jeonghanlee" "gconpi"
exit

