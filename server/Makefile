#
# File: Makefile
# Desc: Makefile of the whole Ark XProject
# Date: Sep.06.2004
#
ROOT_DIR:=.

include $(ROOT_DIR)/Makefile.include

MODULES:=Utility AsioNetwork OTLDataBase

all:
	@for i in $(MODULES); do \
		cd $$i && $(MAKE) && cd ..; \
	done;

clean:
	@for i in $(MODULES); do \
		cd $$i && $(MAKE) clean && cd ..; \
	done;