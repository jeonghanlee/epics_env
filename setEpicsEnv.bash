#!/bin/bash
# Shell  : setEpicsEnv.bash
# Author : Jeong Han Lee
# email  : jeonghan.lee@gmail.com

# 
# PREFIX : SC_, so declare -p can show them in a place
# 
# Generic : Global vaiables - readonly
#

sc_top="$(dirname "$(realpath "$0")")"


export EPICS_HOST_ARCH=linux-x86_64
export EPICS_PATH=${sc_top}
export EPICS_BASE=${EPICS_PATH}/epics-base
export EPICS_EXTENSIONS=${EPICS_PATH}/extensions
export EPICS_MODULES=${EPICS_PATH}/epics-modules
export EPICS_APPS=${EPICS_PATH}/epics-Apps


export PATH=${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
export LD_LIBRARY_PATH=${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}:${EPICS_BASE}/lib/${EPICS_HOST_ARCH}

