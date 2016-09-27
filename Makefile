# Makefile is copied from https://github.com/mdavidsaver/v4workspace

EPICS_BASE=$(CURDIR)/epics-base
EPICS_MODULES=$(CURDIR)/epics-modules
MODULE_ASYN=$(EPICS_MODULES)/asyn
MODULE_STREAM=$(EPICS_MODULES)/stream
MODULE_AUTOSAVE=$(EPICS_MODULES)/autosave
MODULE_MODBUS=$(EPICS_MODULES)/modbus
MODULE_IOCSTATS=$(EPICS_MODULES)/iocStats
MODULE_SSCAN=$(EPICS_MODULES)/sscan
MODULE_BUSY=$(EPICS_MODULES)/busy


export EPICS_BASE
export EPICS_MODULES


all: RELEASE.local modules
	$(MAKE) -C $(EPICS_BASE)
	# $(MAKE) -C $(ASYN)
	# $(MAKE) -C $(STREAM)
	# $(MAKE) -C $(AUTOSAVE)
	# $(MAKE) -C $(MODBUS)
	# $(MAKE) -C $(IOCSTATS)
	# $(MAKE) -C $(SSCAN)
	# $(MAKE) -C $(BUSY)
	$(MAKE) -C $(MODULE_ASYN)
	$(MAKE) -C $(MODULE_STREAM)
	$(MAKE) -C $(MODULE_AUTOSAVE)
	$(MAKE) -C $(MODULE_MODBUS)
	$(MAKE) -C $(MODULE_IOCSTATS)
	$(MAKE) -C $(MODULE_SSCAN)
	$(MAKE) -C $(MODULE_BUSY)
##	$(MAKE) -C $(EPICS_MODULES)/devlib2

clean:
	rm -f RELEASE.local
	rm -f *~

modules:
	echo "EPICS_BASE=$(EPICS_BASE)" > $(MODULE_ASYN)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" > $(MODULE_STREAM)/configure/RELEASE
	echo "ASYN=$(MODULE_ASYN)" >> $(MODULE_STREAM)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" > $(MODULE_AUTOSAVE)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" > $(MODULE_MODBUS)/configure/RELEASE
	echo "ASYN=$(MODULE_ASYN)" >> $(MODULE_MODBUS)/configure/RELEASE	
	echo "EPICS_BASE=$(EPICS_BASE)" > $(MODULE_IOCSTATS)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" > $(MODULE_SSCAN)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" > $(MODULE_BUSY)/configure/RELEASE
	echo "ASYN=$(MODULE_ASYN)" >> $(MODULE_BUSY)/configure/RELEASE



RELEASE.local: RELEASE.local.in
	echo "THE_ROOT_DIR=$$PWD" > $@
	cat $< >> $@

.PHONY: all clean
