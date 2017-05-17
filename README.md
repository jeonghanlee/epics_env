A Simple and Naive EPICS Environment (SNEE)
=================

## Purpose

* To develop a generic way to build an entire EPICS environment in order to make an EPICS environment transparent well to the community.
* To provide an EPICS environment to beginners easily.
* To provide an independent EPICS environment in order to debug existent EPICS environments.

## Limitation
* Due to lack of my knowledge and some warnings from experts, I am using the simplest model of using submodules which is found in https://git-scm.com/book/en/v2/Git-Tools-Submodules

> The simplest model of using submodules in a project would be if you were simply consuming a subproject and wanted to get updates from it from time to time but were not actually modifying anything in your checkout.

  So I DO NOT change any sub modules in this branch (work), DO NOT commit my local changes to the original repositories. 

* All source codes and compiled binary files in the source directories
* By default, selection procedure excludes alpha, beta, pre, and release candidate versions. If one needs that excluded version, one should change epics_env_setup.bash.


## Supported EPICS Modules

### SRC : www.github.com/epics-modules

* autosave
* ipac
* devlib2
* iocStats
* sscan
* asyn
* busy
* modbus
* stream
* calc
* motor
* mrfioc2

### SRC : www-csr.bessy.de/control/SoftDist/sequencer/repo/branch-2-2

* seq


## Setup SNEE


### Case 1 : Fresh Installation or Change BASE version 

Note that if BASE is changed to different version, all modules must be re-compiled according to the BASE.

```
$ git clone https://github.com/jeonghanlee/epics_env

$ cd epics_env

epics_env (master) $ make
--------------------------------------- 
Available targets
--------------------------------------- 
all             same as 'make epics'
epics           Setup EPICS Environment
base            Setup only EPICS BASE, needed to execute modules
modules         Setup only EPICS modules, useful to switch different module version
clean           Clean BASE and all modules
modules-clean   Clean only all modules
env             Print basic EPICS environment variables
init            Get EPICS BASE source, mandatory to run it first

epics_env (master)$ make init
git submodule sync
Synchronizing submodule url for 'epics-base'
git submodule init /home/jhlee/epics_env/epics-base
git submodule update --init --recursive /home/jhlee/epics_env/epics-base/.


epics_env (master) $ make env
EPICS_BASE          : /home/jhlee/epics_env/epics-base
EPICS_MODULES       : /home/jhlee/epics_env/epics-modules
EPICS_APPS          : /home/jhlee/epics_env/epics-Apps
EPICS_HOST_ARCH     : linux-x86_64
EPICS_APPS          : /home/jhlee/epics_env/epics-Apps

epics_env (master) $ make epics

...........

>>>> You are entering in : git_selection
 0: git src                             master
 1: git src                          R3.16.0.1
 2: git src                            R3.15.5
 3: git src                            R3.15.4
 4: git src                            R3.15.3
 5: git src                            R3.15.2
 6: git src                            R3.15.1
 7: git src                          R3.15.0.2
 8: git src                          R3.15.0.1
 9: git src                         R3.14.12.6
10: git src                         R3.14.12.5
11: git src                         R3.14.12.4
12: git src                         R3.14.12.3
13: git src                         R3.14.12.2
14: git src                         R3.14.12.1
15: git src                           R3.14.12
16: git src                           R3.14.11
17: git src                           R3.14.10
18: git src                            R3.14.9
19: git src                          R3.14.8.2
20: git src                          R3.14.8.1
Select master or one of tags which can be built, followed by [ENTER]: 2

....................
....................

>>>> You are entering in : select_epics_modules
./motor

>>>> You are entering in : git_selection
 0: git src                             master
 1: git src                        synApps_5_8
 2: git src                        synApps_5_7
 3: git src                        synApps_5_6
 4: git src                               R6-9
 5: git src                             R6-8-1
 6: git src                               R6-8
 7: git src                             R6-7-1
 8: git src                               R6-7
 9: git src                             R6-6-2
10: git src                             R6-6-1
11: git src                               R6-6
12: git src                             R6-5-2
13: git src                                GIT
Select master or one of tags which can be built, followed by [ENTER]:


..............................
..............................


<<<< You are leaving from select_epics_modules
make -C /home/jhlee/epics_env/epics-modules


```

### Case 2 : Change a Module version


```
$ cd epics_env

epics_env (master) $ make modules
make -C /home/jhlee/epics_env/epics-modules init
make[1]: Entering directory '/home/jhlee/epics_env/epics-modules'
git submodule sync
Synchronizing submodule url for 'asyn'

..............................
..............................

>>>> You are entering in : select_epics_modules
./motor

>>>> You are entering in : git_selection
 0: git src                             master
 1: git src                        synApps_5_8
 2: git src                        synApps_5_7
 3: git src                        synApps_5_6
 4: git src                               R6-9
 5: git src                             R6-8-1
 6: git src                               R6-8
 7: git src                             R6-7-1
 8: git src                               R6-7
 9: git src                             R6-6-2
10: git src                             R6-6-1
11: git src                               R6-6
12: git src                             R6-5-2
13: git src                                GIT
Select master or one of tags which can be built, followed by [ENTER]:




```




### Flexiable EPICS Environment

By default, no change in shell environment, one should source its environment manually via

```
$ . epics_env/setEpicsEnv.bash
```

Then, other EPICS commands are alive in that console only.

```
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
 
$ caget
No pv name specified. ('caget -h' for help.)

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


## Issues

* ESS CentOS 7 has no re2c, so manual installation is needed in order to use SNCSEQ. 

```
[]$ git clone https://github.com/skvadrik/re2c
[]$ cd re2c/re2c/
[re2c]$ ./autogen.sh 
[re2c]$ ./configure 
[re2c]$ make
[re2c]$ sudo make install
Reconfigure to rebuild docs: ./configure --enable-docs
make[1]: Entering directory `/home/iocuser/gitsrc/re2c/re2c'
 /usr/bin/mkdir -p '/usr/local/bin'
  /usr/bin/install -c re2c '/usr/local/bin'
 /usr/bin/mkdir -p '/usr/local/share/man/man1'
 /usr/bin/install -c -m 644 doc/re2c.1 '/usr/local/share/man/man1'
make[1]: Leaving directory `/home/iocuser/gitsrc/re2c/re2c'
```

* Required Packages for ESS CentOS 7.1 1503 
```
perl-Pod-Checker

```
