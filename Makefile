SRC_DIR=src
CONSTRAINTS_DIR=constraints
BUILD_DIR=build

# File names
TOP=top
PCF=constraints.pcf

# Tools
YOSYS=yosys
NEXTPNR=nextpnr-ice40 --package cb132
ICEPACK=icepack
LOADER=alchitry-loader

# Targets
all: $(BUILD_DIR)/$(TOP).bin

$(BUILD_DIR)/$(TOP).json: $(SRC_DIR)/$(TOP).v | $(BUILD_DIR)
	$(YOSYS) -p "synth_ice40 -top $(TOP) -json $@" $<

$(BUILD_DIR)/$(TOP).asc: $(BUILD_DIR)/$(TOP).json $(PCF)
	$(NEXTPNR) --hx8k --json $< --asc $@ --pcf $(PCF)

$(BUILD_DIR)/$(TOP).bin: $(BUILD_DIR)/$(TOP).asc
	$(ICEPACK) $< $@

upload: $(BUILD_DIR)/$(TOP).bin
	$(LOADER) -b Cu -f $<

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all upload clean
