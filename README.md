EPICS Environment
=================

# Purpose

* To develop a generic way to build an entire EPICS environment in order to make ESS EPICS environment transparent well to the community.

* Due to lack of my knowledge and some warnings from experts, I am using the simplest model of using submodules which is found in https://git-scm.com/book/en/v2/Git-Tools-Submodules


> The simplest model of using submodules in a project would be if you were simply consuming a subproject and wanted to get updates from it from time to time but were not actually modifying anything in your checkout.

  So I DO NOT change any sub modules in this branch (work), DO NOT commit my local changes to the original repositories. 



# Commands


## Clone

* Command set 1
```
git clone https://github.com/jeonghanlee/epics_env
cd epics_env/
git submodule init
git submodule update
```

* Command set 2
```
git clone --recursive https://github.com/jeonghanlee/epics_env
```

## Set a specific version of base, and each module
* Select 0, if one wants to use **Master** branch

```
$ bash epics_env_setup.bash 
```
Select one of git tags which one wants to install.

## Make
```
$ make clean
$ make

```

# add a submodule

* add it into 

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


# known problems

* somehow, EPICS_HOST_ARCH returned value has the strange string like debian8. So it is sometimes necessary to set EPICS_HOST_ARCH first
```
export EPICS_HOST_ARCH="linux-x86_64"
```
