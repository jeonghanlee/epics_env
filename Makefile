
TOP = $(CURDIR)
include $(TOP)/configure/CONFIG


all: base modules

base:
	$(MAKE) -C $(EPICS_BASE)

modules: base
	$(MAKE) -C $(EPICS_MODULES)

modules-release:
	$(MAKE) -C $(EPICS_MODULES) release

clean: modulesclean baseclean
	rm -f *~

baseclean:
	$(MAKE) -C $(EPICS_BASE) clean

modulesclean:
	$(MAKE) -C $(EPICS_MODULES) clean



check:
	@echo $(EPICS_BASE)
	@echo $(EPICS_MODULES)
	@echo $(EPICS_APPS)
	@echo $(EPICS_HOST_ARCH)



.PHONY: all clean baseclean modulesclean base modules modules-release
