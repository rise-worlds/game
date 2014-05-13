ROOT_DIR:=..

include $(ROOT_DIR)/Makefile.include

MODULES:=\
	CThread.o \
	Console.o \
	SGLog.o \
	FileSystemUtil.o \
	CMemory.o \
	CMemoryStatistic.o \
	CSmallObject.o \
	CTimer.o \
	FuncPerformanceLog.o \
	Ini.o \
	MarkupSTL.o \
	ShareMem.o \
	Memory.o

INCLUDE:=-I. -I..
TARGET_LIB:=Utility.so
DEPEND_LIB:=

all: $(TARGET_LIB)

$(TARGET_LIB) : $(DEPENDENCIES)
	@$(ECHO) $(STR_SHARED)
	@$(CC) $(CSHARED) $(TARGET_LIB) *.o -L$(ROOT_DIR)/$(BIN_DIR) $(DEPEND_LIB)
	@$(ECHO) $(STR_COPY)
	@$(CP) $(TARGET_LIB) $(ROOT_DIR)/$(BIN_DIR)/$(BUILD_FLAG)

%.o: %.cpp
	@echo $(STR_COMPILE): $@ 
	@$(CC) $(CMODULE) $< $(INCLUDE)