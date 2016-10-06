Simple EPICS Environment
=================

## Purpose

* To develop a generic way to build an entire EPICS environment in order to make an EPICS environment transparent well to the community.
* To provide a simple EPICS environment to biginners easily. 

## Limitation
* Due to lack of my knowledge and some warnings from experts, I am using the simplest model of using submodules which is found in https://git-scm.com/book/en/v2/Git-Tools-Submodules


> The simplest model of using submodules in a project would be if you were simply consuming a subproject and wanted to get updates from it from time to time but were not actually modifying anything in your checkout.

  So I DO NOT change any sub modules in this branch (work), DO NOT commit my local changes to the original repositories. 



## Commands


### Clone


* Command set 1
```
git clone --recursive https://github.com/jeonghanlee/epics_env
```

* Command set 2
```
git clone https://github.com/jeonghanlee/epics_env
cd epics_env/
git submodule init
git submodule update
```

### Set a specific version of base, and each module
* For EPICS base : it has no master branch, thus, select specfic version 3.15.4 (88)
* For EPICS modules : [ENTER] or 0 + [ENTER] means that you select the master branch/
```
$ bash epics_env_setup.bash 
```

### Make
```
$ make
```
### EPICS Environment

```
$ source setEpicsEnv.bash

$ makeBaseApp.pl 
Usage:
<base>/bin/<arch>/makeBaseApp.pl -h
             display help on command options
<base>/bin/<arch>/makeBaseApp.pl -l [options]
             list application types
<base>/bin/<arch>/makeBaseApp.pl -t type [options] [app ...]
             create application directories
<base>/bin/<arch>/makeBaseApp.pl -i -t type [options] [ioc ...]
             create ioc boot directories
where
 app  Application name (the created directory will have "App" appended)
 ioc  IOC name (the created directory will have "ioc" prepended)

$ which caget
/home/jhlee/epics_env/epics-base/bin/linux-x86_64/caget
```

## Want to add an additional module
* Note that Makefile in epics-modules should be changed according to any added modules. 

```
git submodule add https://github.com/epics-modules/busy epics-modules/busy
```

* modify .gitmodule
```
[submodule "epics-modules/busy"]
	path = epics-modules/busy
	url = https://github.com/epics-modules/busy
	branch = master
	ignore = dirty
```

* push it to the working branch


## known problems

* somehow, EPICS_HOST_ARCH returned value has the strange string like debian8. So it is sometimes necessary to set EPICS_HOST_ARCH first
```
export EPICS_HOST_ARCH="linux-x86_64"
```
