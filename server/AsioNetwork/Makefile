ROOT_DIR:=..

include $(ROOT_DIR)/Makefile.include

MODULES:=\
	AsioNetwork.o \
	IoHandler.o \
	NetObject.o \
	Session.o \
	SessionList.o \
	SessionPool.o

INCLUDE:=-I. -I.. -I../Boost/include
TARGET_LIB:=AsioNetwork.so
DEPEND_LIB:=$(BASEROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)/SGutility.so ../Boost/lib/libboost_date_time-gcc43-mt-sd-1_39.a ../Boost/lib/libboost_regex-gcc43-mt-sd-1_39.a ../Boost/lib/libboost_system-gcc43-mt-sd-1_39.a ../Boost/lib/libboost_thread-gcc43-mt-sd-1_39.a

all: $(TARGET_LIB)

$(TARGET_LIB) : $(DEPENDENCIES)
	@$(ECHO) $(STR_SHARED)
	@$(CC) $(CSHARED) $(TARGET_LIB) *.o -L$(ROOT_DIR)/$(BIN_DIR) $(DEPEND_LIB)
	@$(ECHO) $(STR_COPY)
	@$(CP) $(TARGET_LIB) $(ROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)

%.o: %.cpp
	@echo $(STR_COMPILE): $@ 
	@$(CC) $(CMODULE) $< $(INCLUDE)
