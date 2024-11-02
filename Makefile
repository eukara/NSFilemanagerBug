GS_FLAGS=$(shell gnustep-config --objc-flags)
GS_LIBS=$(shell gnustep-config --gui-libs)

TOOLS=NSFileManagerBug

all:
	-$(MAKE) clean
	$(MAKE) $(TOOLS)

NSFileManagerBug:
	$(CC) $(GS_FLAGS) NSFileManagerBug.m $(GS_LIBS) -o NSFileManagerBug
