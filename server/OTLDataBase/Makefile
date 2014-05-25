ROOT_DIR:=..

include $(ROOT_DIR)/Makefile.include

MODULES:=\
	DBTransaction.o \
	OTLDataBase.o

OUT_DIR:=./$(BUILD_FLAG)/
INCLUDE:=-I. -I.. -I../Utility
TARGET_LIB:=OTLDataBase.so
DEPEND_LIB:=

all: $(TARGET_LIB)

$(TARGET_LIB) : $(DEPENDENCIES)
	@$(ECHO) $(STR_SHARED)
	@$(CC) $(CSHARED) $(CFLAG) $(OUT_DIR)$(TARGET_LIB) $(OUT_DIR)*.o -L$(ROOT_DIR)/$(BIN_DIR) $(DEPEND_LIB)
	@$(ECHO) $(STR_COPY)
	@$(CP) $(OUT_DIR)$(TARGET_LIB) $(ROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)

%.o: %.cpp
	@echo $(STR_COMPILE): $(OUT_DIR)$@ 
	@$(CC) $(CSHARED) $(CMODULE) $(CFLAG)$(OUT_DIR)$@ $< $(INCLUDE)
