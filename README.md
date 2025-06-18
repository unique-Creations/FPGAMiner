# FPGAMiner
An open-source FPGA framework for prototyping and testing custom hardware — starting with LED blinking and ramping up to **crypto mining experiments** on the Lattice iCE40HX8K.

Built for portability (via Docker), modularity, and fast iteration, **FPGAMiner** is your digital sandbox to tinker, design, and potentially mine some coins… just don’t expect to retire on an 8K gate budget. 😅

---

## 💡 Project Overview

VeriMiner is:
- A Verilog-based FPGA project using the Alchitry Cu (iCE40HX8K)
- Designed with an open-source toolchain (Yosys, NextPNR, IceStorm)
- Packaged in a cross-platform Docker container
- Capable of testing hardware **crypto mining cores** (e.g., Bitcoin SHA256 pipelines or other PoW designs)

Whether you're just learning FPGA design or experimenting with application-specific hardware like crypto accelerators, this repo has a clean structure and build flow to get you moving.

---

## 🗂️ Project Structure

```bash
FPGAMiner/
├── docker/            # Dockerfile and Docker build context
├── scripts/           # Helper scripts for build/flash/sim
├── src/               # Verilog source files
│   ├── top.v          # Top-level design
│   ├── miner_core.v   # SHA256-based miner core (WIP)
│   └── ...
├── sim/               # Testbenches for miner core and other logic
├── constraints/       # PCF/ACF constraint files
├── build/             # Output: JSON, ASC, BIN
├── Makefile           # Build and flash automation
└── README.md
```
## 🛠️ Toolchain
- yosys: Verilog synthesis
- nextpnr-ice40: Placement and routing
- icepack: Bitstream generation
- alchitry-loader: Flashing to Cu board
- Optional: iverilog/verilator for simulation
- Containerized using Docker