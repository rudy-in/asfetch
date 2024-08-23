# Compiler and linker
AS = nasm
LD = ld

# Compiler flags
ASFLAGS = -f elf64
LDFLAGS =

# Directories
SRC_DIR = src
OBJ_DIR = obj
COMPONENTS_DIR = $(OBJ_DIR)/components

# Source and object files
SRC_FILES = $(wildcard $(SRC_DIR)/**/*.asm) $(SRC_DIR)/*.asm
OBJ_FILES = $(patsubst $(SRC_DIR)/%.asm, $(OBJ_DIR)/%.o, $(SRC_FILES))

# Target executable
TARGET = asfetch

# Default target
all: $(TARGET)

# Create object directory
$(OBJ_DIR) $(COMPONENTS_DIR):
	mkdir -p $(COMPONENTS_DIR)

# Build target executable
$(TARGET): $(OBJ_FILES)
	$(LD) $(LDFLAGS) -o $@ $(OBJ_FILES)

# Build object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm | $(OBJ_DIR) $(COMPONENTS_DIR)
	$(AS) $(ASFLAGS) -o $@ $<

# Clean up
clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET)
	rmdir $(OBJ_DIR)

# Phony targets
.PHONY: all clean
