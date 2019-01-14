# _____     ___ ____     ___ ____
#  ____|   |    ____|   |        | |____|
# |     ___|   |____ ___|    ____| |    \    PS2DEV Open Source Project.
#-----------------------------------------------------------------------
# Copyright 2001-2004.
# Licenced under Academic Free License version 2.0
# Review ps2sdk README & LICENSE files for further details.

EE_CC_VERSION := $(shell $(EE_CC) -dumpversion 2>&1)

EE_INCS := $(EE_INCS) -I$(PS2SDK)/ee/include -I$(PS2SDK)/common/include -I$(GSKIT)/ee/dma/include -I$(GSKIT)/ee/gs/include

# C compiler flags
EE_CFLAGS := -D_EE -G0 -O2 -Wall $(EE_INCS) $(EE_CFLAGS)

#ifdef GSKIT_DEBUG
#	EE_CFLAGS += -DGSKIT_DEBUG
#endif

# C++ compiler flags
EE_CXXFLAGS := -D_EE -G0 -O2 -Wall $(EE_INCS) $(EE_CXXFLAGS)

#ifdef GSKIT_DEBUG
#	EE_CXXFLAGS += -DGSKIT_DEBUG
#endif

# Linker flags
#EE_LDFLAGS := $(EE_LDFLAGS)

# Assembler flags
EE_ASFLAGS := $(EE_ASFLAGS)

# Externally defined variables: EE_BIN, EE_OBJS, EE_LIB

# These macros can be used to simplify certain build rules.
EE_C_COMPILE = $(EE_CC) $(EE_CFLAGS)
EE_CXX_COMPILE = $(EE_CXX) $(EE_CXXFLAGS)

# Extra macro for disabling the automatic inclusion of the built-in CRT object(s)
ifeq ($(EE_CC_VERSION),3.2.2)
EE_NO_CRT = -mno-crt0
endif
ifeq ($(EE_CC_VERSION),3.2.3)
EE_NO_CRT = -mno-crt0
endif
ifneq ($(EE_CC_VERSION),3.2.2)
ifneq ($(EE_CC_VERSION),3.2.3)
EE_NO_CRT = -nostartfiles
endif
endif

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.c
	$(EE_CC) $(EE_CFLAGS) -c $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.cpp
	$(EE_CXX) $(EE_CXXFLAGS) -c $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.S
	$(EE_CC) $(EE_CFLAGS) -c $< -o $@

$(EE_OBJS_DIR)%.o: $(EE_SRC_DIR)%.s
	$(EE_AS) $(EE_ASFLAGS) $< -o $@

$(EE_LIB_DIR):
	mkdir -p $(EE_LIB_DIR)

$(EE_BIN_DIR):
	mkdir -p $(EE_BIN_DIR)

$(EE_OBJS_DIR):
	mkdir -p $(EE_OBJS_DIR)

ifeq ($(use_cpp), true)
$(EE_BIN): $(EE_OBJS)
	$(EE_CXX) $(EE_NO_CRT) $(EE_LDFLAGS) -o $(EE_BIN) $(EE_OBJS) $(EE_LIBS)
else
$(EE_BIN): $(EE_OBJS)
	$(EE_CC) $(EE_NO_CRT) $(EE_LDFLAGS) -o $(EE_BIN) $(EE_OBJS) $(EE_LIBS)
endif

$(EE_LIB): $(EE_OBJS)
	$(EE_AR) cru $(EE_LIB) $(EE_OBJS)
