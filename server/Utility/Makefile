ROOT_DIR:=..

include $(ROOT_DIR)/Makefile.include

MODULES:=\
	CThread.o \
	CTimer.o \
	FileSystemUtil.o \
	FuncPerformanceLog.o \
	Log.o \
	MarkupSTL.o \
	Ini.o \
	Console.o \
	ShareMem.o 

OUT_DIR:=./$(BUILD_FLAG)/
INCLUDE:=-I. -I..
TARGET_LIB:=Utility.so
DEPEND_LIB:=

all: 
	ifeq "$(wildcard $(OUT_DIR))" ""
		mkdir $(OUT_DIR)
		echo "directory not existed"
	else
		echo "directory existed"
	endif
	$(TARGET_LIB)

$(TARGET_LIB) : $(DEPENDENCIES)
	@$(ECHO) $(STR_SHARED)
	@$(CC) $(CSHARED) $(CFLAG) $(OUT_DIR)$(TARGET_LIB) $(OUT_DIR)*.o -L$(ROOT_DIR)/$(BIN_DIR) $(DEPEND_LIB)
	@$(ECHO) $(STR_COPY)
	@$(CP) $(OUT_DIR)$(TARGET_LIB) $(ROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)

%.o: %.cpp
	@echo $(STR_COMPILE): $(OUT_DIR)$@ 
	@$(CC) $(CSHARED) $(CMODULE) $(CFLAG)$(OUT_DIR)$@ $< $(INCLUDE)
