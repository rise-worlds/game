ROOT_DIR:=..

include $(ROOT_DIR)/Makefile.include

OUT_DIR:=./$(BUILD_FLAG)/
INCLUDE:=-I. -I..
TARGET_LIB:=$(OUT_DIR)DBAgent.so
DEPEND_LIB:=$(BASEROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)/Utility.so \
	$(BASEROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)/AsioNetwork.so \
	$(BASEROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)/OTLDataBase.so

MODULES:=\
	DBUser.o \
	DBUserMgr.o \
	LoginSession.o \
	DBAgent.o \
	CMaster.o

all: $(TARGET_LIB)

$(TARGET_LIB) : $(DEPENDENCIES)
	@$(ECHO) $(STR_SHARED)
	@$(CC) $(CSHARED) $(CFLAG)$(TARGET_LIB) $(OUT_DIR)*.o -L$(ROOT_DIR)/$(BIN_DIR) $(LIB_ODBC) $(DEPEND_LIB)
	@$(ECHO) $(STR_COPY)
	@$(CP) $(TARGET_LIB) $(ROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)

%.o: %.cpp
	@echo $(STR_COMPILE): $(OUT_DIR)$@ 
	@$(CC) $(CSHARED) $(CMODULE) $(CFLAG)$(OUT_DIR)$@ $< $(INCLUDE)