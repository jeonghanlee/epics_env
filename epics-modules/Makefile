# Makefile is copied from https://github.com/mdavidsaver/v4workspace
# TODO Modules
#
# CAPUTLOG

TOP = ..

#BASE[o]
M_AUTOSAVE=$(EPICS_MODULES)/autosave
M_IPAC=$(EPICS_MODULES)/ipac
M_DEVLIB2=$(EPICS_MODULES)/devlib2
M_SNCSEQ=$(EPICS_MODULES)/seq
#BASE[o], SNCSEQ[o]
M_IOCSTATS=$(EPICS_MODULES)/iocStats
M_SSCAN=$(EPICS_MODULES)/sscan
#BASE[o], IPAC[o], SNCSEQ[o]
M_ASYN=$(EPICS_MODULES)/asyn
#BASE[o], ASYN[o]
M_BUSY=$(EPICS_MODULES)/busy
M_MODBUS=$(EPICS_MODULES)/modbus
M_STREAM=$(EPICS_MODULES)/stream
#BASE[o], SSCAN[o], SNCSEQ[o]
M_CALC=$(EPICS_MODULES)/calc
#BASE[o], ASYN[o], BUSY[o], IPAC[o], SNCSEQ[o]
M_MOTOR=$(EPICS_MODULES)/motor
#BASE[o], DEVLIB2[o], DEVIOCSTATS[o], AUTOSAVE[x], CAPUTLOG[x]
M_MRFIOC2=$(EPICS_MODULES)/mrfioc2




M_DIRS:=$(sort $(dir $(wildcard */)))


all: modules

modules: release
#	BASE[o]
	$(MAKE) -C $(M_AUTOSAVE)
	$(MAKE) -C $(M_IPAC)
	$(MAKE) -C $(M_DEVLIB2)
	$(MAKE) -C $(M_SNCSEQ)
#	BASE[o], SNCSEQ[o]
	$(MAKE) -C $(M_IOCSTATS)
	$(MAKE) -C $(M_SSCAN)
#	BASE[o], IPAC[o], SNCSEQ[o]
	$(MAKE) -C $(M_ASYN)
#	BASE[o], ASYN[o]
	$(MAKE) -C $(M_BUSY)
	$(MAKE) -C $(M_MODBUS)
	$(MAKE) -C $(M_STREAM)
#	BASE[o], SSCAN[o], SNCSEQ[o]
	$(MAKE) -C $(M_CALC)
#	BASE[o], ASYN[o], BUSY[o], IPAC[o], SNCSEQ[o]
	$(MAKE) -C $(M_MOTOR)
#	BASE[o], DEVLIB2[o], DEVIOCSTATS[o], AUTOSAVE[x], CAPUTLOG[x]
	$(MAKE) -C $(M_MRFIOC2)



release:
#	BASE[o]
	@echo "EPICS_BASE=$(EPICS_BASE)"  > $(M_AUTOSAVE)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)"  > $(M_IPAC)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)"  > $(M_DEVLIB2)/configure/RELEASE.local
	@echo "EPICS_BASE=$(EPICS_BASE)"  > $(M_SNCSEQ)/configure/RELEASE
#	BASE[o], SNCSEQ[o]
	@echo "SNCSEQ=$(M_SNCSEQ)"        > $(M_IOCSTATS)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_IOCSTATS)/configure/RELEASE
	@echo "SNCSEQ=$(M_SNCSEQ)"        > $(M_SSCAN)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_SSCAN)/configure/RELEASE
#	BASE[o], IPAC[o], SNCSEQ[o]
	@echo "IPAC=$(M_IPAC)"            > $(M_ASYN)/configure/RELEASE
	@echo "SNCSEQ=$(M_SNCSEQ)"       >> $(M_ASYN)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_ASYN)/configure/RELEASE
#	BASE[o], ASYN[o]
	@echo "ASYN=$(M_ASYN)"            > $(M_BUSY)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_BUSY)/configure/RELEASE
	@echo "ASYN=$(M_ASYN)"            > $(M_MODBUS)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_MODBUS)/configure/RELEASE
	@echo "ASYN=$(M_ASYN)"            > $(M_STREAM)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_STREAM)/configure/RELEASE
#	BASE[o], SSCAN[o], SNCSEQ[o]
	@echo "SSCAN=$(M_SSCAN)"          > $(M_CALC)/configure/RELEASE
	@echo "SNCSEQ=$(M_SNCSEQ)"       >> $(M_CALC)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_CALC)/configure/RELEASE
#	BASE[o], ASYN[o], BUSY[o], IPAC[o], SNCSEQ[o]
	@echo "ASYN=$(M_ASYN)"            > $(M_MOTOR)/configure/RELEASE
	@echo "SNCSEQ=$(M_SNCSEQ)"       >> $(M_MOTOR)/configure/RELEASE
	@echo "IPAC=$(M_IPAC)"           >> $(M_MOTOR)/configure/RELEASE
	@echo "BUSY=$(M_BUSY)"           >> $(M_MOTOR)/configure/RELEASE
	@echo "EPICS_BASE=$(EPICS_BASE)" >> $(M_MOTOR)/configure/RELEASE
#	BASE[o], DEVLIB2[o], DEVIOCSTATS[o], AUTOSAVE[o], CAPUTLOG[x]
	@echo "DEVLIB2=$(M_DEVLIB2)"       > $(M_MRFIOC2)/configure/RELEASE.local
	@echo "DEVIOCSTATS=$(M_IOCSTATS)" >> $(M_MRFIOC2)/configure/RELEASE.local
	@echo "AUTOSAVE=$(M_AUTOSAVE)"    >> $(M_MRFIOC2)/configure/RELEASE.local
	@echo "EPICS_BASE=$(EPICS_BASE)"  >> $(M_MRFIOC2)/configure/RELEASE.local


clean: $(M_DIRS)

$(M_DIRS):
	$(MAKE) -C $@ clean

init: 
	@git submodule deinit -f $(EPICS_MODULES)/
	git submodule deinit -f $(EPICS_MODULES)/
	sed -i '/submodule/,$$d'  $(TOP)/.git/config	
#	$(foreach dir, $(M_DIRS), git rm --cached $(dir))
	git submodule init  $(EPICS_MODULES)/
	git submodule update --init --remote --recursive $(EPICS_MODULES)/

# RELEASE.local: RELEASE.local.in
# 	echo "THE_ROOT_DIR=$$PWD" > $@
# 	cat $< >> $@

dirs:
	@echo $(M_DIRS) || true
	@echo $(findstring asyn, $(M_DIRS))



# # In case, .gitmodules may be modified.
# # 
# git-msync:
# 	git submodule sync



.PHONY: all clean release dirs $(M_DIRS) init git-msync
