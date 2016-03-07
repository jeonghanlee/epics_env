# Makefile is copied from https://github.com/mdavidsaver/v4workspace

all: RELEASE.local
	$(MAKE) -C epics-base
	$(MAKE) -C epics-modules/asyn
	$(MAKE) -C epics-modules/iocStats

clean:
	rm -f RELEASE.local
	rm -f *~

RELEASE.local: RELEASE.local.in
	echo "THE_ROOT_DIR=$$PWD" > $@
	cat $< >> $@

.PHONY: all clean
