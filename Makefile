
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

# In the case that modules-release never be executed before,
# it will reduce the error messages during make

## Clean only all modules
modules-clean: modules-release
	$(MAKE) -C $(EPICS_MODULES) clean

# Makefile in modules runs "release" internally
modules-release: 
	$(MAKE) -C $(EPICS_MODULES) release

## Print basic EPICS environment variables
env:
	@echo ""
	@echo "EPICS_BASE          : "$(EPICS_BASE)
	@echo "EPICS_MODULES       : "$(EPICS_MODULES)
	@echo "EPICS_APPS          : "$(EPICS_APPS)
	@echo "EPICS_HOST_ARCH     : "$(EPICS_HOST_ARCH)
	@echo ""
#	@echo "EPICS_APPS          : "$(EPICS_APPS)


# Exclude EPICS_MODULES
M_DIRS:=$(sort $(dir $(wildcard $(EPICS_MODULES)/*/.)))

#
## Get EPICS BASE source, mandatory to run it first
init:  
	git submodule init $(EPICS_BASE)
	git submodule update --init --recursive $(EPICS_BASE)/.

base-init:  git-msync
	@git submodule deinit -f $(EPICS_BASE)/
	git submodule deinit -f $(EPICS_BASE)/
	sed -i '/submodule/,$$d'  $(TOP)/.git/config	
	git submodule init $(EPICS_BASE)
	git submodule update --init --recursive $(EPICS_BASE)/.


# CentOS 7 git doesn't allow to run the following commands in EPICS_MODULES
#
modules-init: git-msync
	@git submodule deinit -f $(EPICS_MODULES)/
	git submodule deinit -f $(EPICS_MODULES)/
	sed -i '/submodule/,$$d'  $(TOP)/.git/config	
#	$(foreach dir, $(M_DIRS), git rm --cached $(dir))
	git submodule init  $(EPICS_MODULES)/
	git submodule update --init --remote --recursive $(EPICS_MODULES)/



# Git init base, and select a version (tag) of BASE
sel-base: base-init
	$(TOP)/epics_env_setup.bash base

# Git init modules, and select a version (tag) of each module
sel-modules: modules-init
#	$(MAKE) -C $(EPICS_MODULES) init	
	$(TOP)/epics_env_setup.bash modules

#sel-all: init
#	$(TOP)/epics_env_setup.bash all


# In the fresh installation, it doesn't matter.
# It is only valuable once .gitmodules may be modified.
git-msync:
	git submodule sync	


dirs:
	@echo $(M_DIRS) || true





.PHONY: all epics base modules modules-release clean base-clean modules-clean env init base-init modules-init sel-base sel-modules git-msync help 
