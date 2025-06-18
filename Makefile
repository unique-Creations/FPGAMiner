# File names
TOP=top
PCF=constraints.pcf

# Tools
YOSYS=yosys
NEXTPNR=nextpnr-ice40 --package cb132
ICEPACK=icepack
LOADER=alchitry-loader

# Targets
all: ${TOP}.bin

${TOP}.json: ${TOP}.v
	${YOSYS} -p "synth_ice40 -top ${TOP} -json ${TOP}.json" ${TOP}.v

${TOP}.asc: ${TOP}.json ${PCF}
	${NEXTPNR} --hx8k --json ${TOP}.json --asc ${TOP}.asc --pcf ${PCF}

${TOP}.bin: ${TOP}.asc
	${ICEPACK} ${TOP}.asc ${TOP}.bin

upload: ${TOP}.bin
	${LOADER} -b Cu -f ${TOP}.bin

clean:
	rm -f *.json *.asc *.bin

.PHONY: all upload clean
