ROOT_DIR:=..

include $(ROOT_DIR)/Makefile.include

MODULES:=\
	DBTransaction.o \
	OTLDatabase.o

INCLUDE:=-I. -I..
TARGET_LIB:=OTLDataBase.so
DEPEND_LIB:=$(BASEROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)/Utility.so

all: $(TARGET_LIB)

$(TARGET_LIB) : $(DEPENDENCIES)
	@$(ECHO) $(STR_SHARED)
	@$(CC) $(CSHARED) $(TARGET_LIB) *.o -L$(ROOT_DIR)/$(BIN_DIR) $(LIB_ODBC) $(DEPEND_LIB)
	@$(ECHO) $(STR_COPY)
	@$(CP) $(TARGET_LIB) $(ROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)

%.o: %.cpp
	@echo $(STR_COMPILE): $@ 
	@$(CC) $(CMODULE) $< $(INCLUDE)