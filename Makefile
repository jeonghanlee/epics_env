
TOP = $(CURDIR)
include $(TOP)/configure/CONFIG

# help is defined in 
# https://gist.github.com/rcmachado/af3db315e31383502660
help:
	$(info --------------------------------------- )	
	$(info Available targets)
	$(info --------------------------------------- )
	@awk '/^[a-zA-Z\-\_0-9]+:/ {                    \
	  nb = sub( /^## /, "", helpMsg );              \
	  if(nb == 0) {                                 \
	    helpMsg = $$0;                              \
	    nb = sub( /^[^:]*:.* ## /, "", helpMsg );   \
	  }                                             \
	  if (nb)                                       \
	    print  $$1 "\t" helpMsg;                    \
	}                                               \
	{ helpMsg = $$0 }'                              \
	$(MAKEFILE_LIST) | column -ts:	

## same as 'make epics'
all: epics  

## Setup EPICS Environment
epics: base modules 

## Setup only EPICS BASE, needed to execute modules
base: sel-base
	$(MAKE) -C $(EPICS_BASE)


## Setup only EPICS modules, useful to switch different module version
modules: sel-modules 
	$(MAKE) -C $(EPICS_MODULES)

## Clean BASE and all modules
clean: modules-clean base-clean
	rm -f *~

# Clean only base, so, all modules should be clean also.
base-clean:
	$(MAKE) -C $(EPICS_BASE) clean

# In the case that modules-relase never be executed before,
# it will reduce the error messages during make

## Clean only all modules
modules-clean: modules-release
	$(MAKE) -C $(EPICS_MODULES) clean

# Makefile in modules runs "release" internally
modules-release: 
	$(MAKE) -C $(EPICS_MODULES) release

## Print basic EPICS enviornment variables
env:
	@echo "EPICS_BASE          : "$(EPICS_BASE)
	@echo "EPICS_MODULES       : "$(EPICS_MODULES)
	@echo "EPICS_APPS          : "$(EPICS_APPS)
	@echo "EPICS_HOST_ARCH     : "$(EPICS_HOST_ARCH)

# # sed needs $$ instead of $ in Makefile
# init: git-msync
# 	@git submodule deinit -f .
# 	git submodule deinit -f .
# 	sed -i '/submodule/,$$d'  $(TOP)/.git/config	
# 	git submodule init 
# 	git submodule update --init --recursive .

# # 
base-init:  git-msync
	@git submodule deinit -f $(EPICS_BASE)/
	git submodule deinit -f $(EPICS_BASE)/
	sed -i '/submodule/,$$d'  $(TOP)/.git/config	
	git submodule init $(EPICS_BASE)
	git submodule update --init --recursive $(EPICS_BASE)/.

# Git init base, and select a version (tag) of BASE
sel-base: base-init
	$(TOP)/epics_env_setup.bash base

# Git init modules, and select a version (tag) of each module
sel-modules:
	$(MAKE) -C $(EPICS_MODULES) init	
	$(TOP)/epics_env_setup.bash modules

#sel-all: init
#	$(TOP)/epics_env_setup.bash all


# In the fresh installation, it doesn't matter.
# It is only valuable once .gitmodules may be modified.
git-msync:
	git submodule sync	


.PHONY: all epics base modules modules-release clean base-clean modules-clean env base-init sel-base sel-modules git-msync help
