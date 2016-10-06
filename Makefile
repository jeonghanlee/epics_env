
EPICS_BASE=$(CURDIR)/epics-base
EPICS_MODULES=$(CURDIR)/epics-modules

export EPICS_BASE
export EPICS_MODULES


all: base modules

base:
	$(MAKE) -C $(EPICS_BASE)

modules:
	$(MAKE) -C $(EPICS_MODULES)

clean:
	rm -f *~
	$(MAKE) -C $(EPICS_MODULES) clean

.PHONY: all clean base modules 
