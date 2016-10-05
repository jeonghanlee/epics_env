# Makefile is copied from https://github.com/mdavidsaver/v4workspace
# TODO Modules
#
# SNCSEQ / IPAC / CAPUTLOG
#
EPICS_BASE=$(CURDIR)/epics-base
EPICS_MODULES=$(CURDIR)/epics-modules

M_ASYN=$(EPICS_MODULES)/asyn
M_AUTOSAVE=$(EPICS_MODULES)/autosave
M_BUSY=$(EPICS_MODULES)/busy
M_CALC=$(EPICS_MODULES)/calc
M_DEVLIB2=$(EPICS_MODULES)/devlib2
M_IOCSTATS=$(EPICS_MODULES)/iocStats
M_MODBUS=$(EPICS_MODULES)/modbus
M_MOTOR=$(EPICS_MODULES)/motor
M_MRFIOC2=$(EPICS_MODULES)/mrfioc2
M_SSCAN=$(EPICS_MODULES)/sscan
M_STREAM=$(EPICS_MODULES)/stream


export EPICS_BASE
export EPICS_MODULES


all: base modules

base:
	$(MAKE) -C $(EPICS_BASE)

modules: release
	$(MAKE) -C $(M_ASYN)
	$(MAKE) -C $(M_AUTOSAVE)
	$(MAKE) -C $(M_IOCSTATS)
	$(MAKE) -C $(M_DEVLIB2)
	$(MAKE) -C $(M_SSCAN)
	$(MAKE) -C $(M_BUSY)
	$(MAKE) -C $(M_CALC)
	$(MAKE) -C $(M_MODBUS)
	$(MAKE) -C $(M_MOTOR)
	$(MAKE) -C $(M_MRFIOC2)
	$(MAKE) -C $(M_STREAM)


release: 
##	ASYN : BASE[*] / SNCSEQ* / IPAC* 
	echo "EPICS_BASE=$(EPICS_BASE)"  > $(M_ASYN)/configure/RELEASE
##	AUTOSAVE : BASE[*] 
	echo "EPICS_BASE=$(EPICS_BASE)"  > $(M_AUTOSAVE)/configure/RELEASE
##	DEVIOCSTATS : BASE[*] / SNCSEQ*
	echo "EPICS_BASE=$(EPICS_BASE)"  > $(M_IOCSTATS)/configure/RELEASE
##      DEVLIB2 : BASE[*]
	echo "EPICS_BASE=$(EPICS_BASE)"  > $(M_DEVLIB2)/configure/RELEASE.local
##	SSCAN : BASE[*] / SNCSEQ 
	echo "EPICS_BASE=$(EPICS_BASE)"  > $(M_SSCAN)/configure/RELEASE
##	BUSY : BASE[*] / ASYN[*}
	echo "ASYN=$(M_ASYN)"            > $(M_BUSY)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_BUSY)/configure/RELEASE
##	CALC : BASE[*] / SSCAN (swait record) / SNCSEQ (editSseq)
	echo "SSCAN=$(M_SSCAN)"          > $(M_CALC)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_CALC)/configure/RELEASE
##	MODBUS : BASE[*] / ASYN[*]
	echo "ASYN=$(M_ASYN)"            > $(M_MODBUS)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_MODBUS)/configure/RELEASE
##	MOTOR : BASE[*] / ASYN[*] / BUSY[*] / SNCSEQ / IPAC
	echo "ASYN=$(M_ASYN)"            > $(M_MOTOR)/configure/RELEASE
	echo "BUSY=$(M_BUSY)"           >> $(M_MOTOR)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_MOTOR)/configure/RELEASE
##	MRFIOC2 : BASE[*] / DEVLIB2[*] / DEVIOCSTATS / AUTOSAVE / CAPUTLOG
	echo "DEVLIB2=$(M_DEVLIB2)"       > $(M_MRFIOC2)/configure/RELEASE.local
	echo "DEVIOCSTATS=$(M_IOCSTATS)" >> $(M_MRFIOC2)/configure/RELEASE.local
	echo "AUTOSAVE=$(M_AUTOSAVE)"    >> $(M_MRFIOC2)/configure/RELEASE.local
	echo "EPICS_BASE=$(EPICS_BASE)"  >> $(M_MRFIOC2)/configure/RELEASE.local
##	STREAM : BASE[*] / ASYNC[*] 
	echo "ASYN=$(M_ASYN)"            > $(M_STREAM)/configure/RELEASE
	echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_STREAM)/configure/RELEASE



clean:
	rm -f RELEASE.local
	rm -f *~


# RELEASE.local: RELEASE.local.in
# 	echo "THE_ROOT_DIR=$$PWD" > $@
# 	cat $< >> $@

.PHONY: all clean
