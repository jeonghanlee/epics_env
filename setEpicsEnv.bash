#!/bin/bash
# Shell  : setEpicsEnv.sh
# Author : Jeong Han Lee
# email  : jeonghan.lee@gmail.com


declare -gr SC_SCRIPT="$(realpath "$0")"
declare -gr SC_SCRIPTNAME="$(basename "$SC_SCRIPT")"
declare -gr SC_TOP="$(dirname "$SC_SCRIPT")"
declare -gr SC_LOGDATE="$(date +%Y%b%d-%H%M-%S%Z)"

export EPICS_HOST_ARCH=linux-x86_64
export EPICS_PATH=${SC_TOP}
export EPICS_BASE=${EPICS_PATH}/epics-base
export EPICS_EXTENSIONS=${EPICS_PATH}/extensions
export EPICS_MODULES=${EPICS_PATH}/epics-modules

export PATH=${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
export LD_LIBRARY_PATH=${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}:${EPICS_BASE}/lib/${EPICS_HOST_ARCH}

