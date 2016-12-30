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
# Shell  : setEpicsEnv.bash
# Author : Jeong Han Lee
# email  : jeonghan.lee@gmail.com


SRC="${BASH_SOURCE[0]}"
SRC_DIR="$( cd -P "$( dirname "$SRC" )" && pwd )"


export EPICS_HOST_ARCH=linux-x86_64
export EPICS_PATH=${SRC_DIR}
export EPICS_BASE=${EPICS_PATH}/epics-base
export EPICS_EXTENSIONS=${EPICS_PATH}/extensions
export EPICS_MODULES=${EPICS_PATH}/epics-modules
export EPICS_APPS=${EPICS_PATH}/epics-Apps
export EPICS_SITEAPPS=${EPICS_PATH}/epics-siteApps
export EPICS_SITELIBS=${EPICS_PATH}/epics-siteLibs

#
# Static PATH and LD_LIBRARY_PATH
# 
export PATH=${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
export LD_LIBRARY_PATH=${EPICS_EXTENSIONS}/lib/${EPICS_HOST_ARCH}:${EPICS_BASE}/lib/${EPICS_HOST_ARCH}

