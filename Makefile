
TOP = .
include $(TOP)/configure/CONFIG


all: base modules

base:
	$(MAKE) -C $(EPICS_BASE)

modules:
	$(MAKE) -C $(EPICS_MODULES)

clean:
	rm -f *~
	$(MAKE) -C $(EPICS_MODULES) clean

.PHONY: all clean base modules 


check:
	@echo $(EPICS_BASE)
	@echo $(EPICS_MODULES)
	@echo $(EPICS_APPS)
	@echo $(EPICS_HOST_ARCH)

