ROOT_DIR:=..

include $(ROOT_DIR)/Makefile.include

MODULES:=\
	AsioNetwork.o \
	IoHandler.o \
	NetObject.o \
	Session.o \
	SessionList.o \
	SessionPool.o

OUT_DIR:=./$(BUILD_FLAG)/
INCLUDE:=-I. -I..
TARGET_LIB:=$(OUT_DIR)AsioNetwork.so
DEPEND_LIB:=$(BASEROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)/Utility.so \
	/usr/local/lib/libboost_date_time.so \
	/usr/local/lib/libboost_regex.so \
	/usr/local/lib/libboost_system.so \
	/usr/local/lib/libboost_thread.so

all: $(TARGET_LIB)

$(TARGET_LIB) : $(DEPENDENCIES)
	@$(ECHO) $(STR_SHARED) $(DEPEND_LIB)
	@$(CC) $(CSHARED) $(CFLAG)$(TARGET_LIB) $(OUT_DIR)*.o -L$(ROOT_DIR)/$(BIN_DIR) $(DEPEND_LIB)
	@$(ECHO) $(STR_COPY)
	@$(CP) $(TARGET_LIB) $(ROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)

%.o: %.cpp
	@echo $(STR_COMPILE): $(OUT_DIR)$@ 
	@$(CC) $(CSHARED) $(CMODULE) $(CFLAG)$(OUT_DIR)$@ $< $(INCLUDE)
