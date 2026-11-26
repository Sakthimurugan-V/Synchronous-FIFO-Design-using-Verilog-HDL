# Synchronous FIFO Design using Verilog HDL

## Overview

This project implements a **Synchronous FIFO (First-In, First-Out) buffer** using Verilog HDL. The FIFO stores 8-bit data and supports sequential write and read operations using a single clock signal.

The design uses read and write pointers to manage data storage and implements `full` and `empty` status flags to monitor FIFO occupancy.

The RTL was simulated and the design was developed using Intel Quartus Prime Lite Edition.

## Features

- Synchronous FIFO architecture
- Configurable FIFO depth and data width using parameters
- Default FIFO depth: 16 entries
- Default data width: 8 bits
- Read and write pointer management
- FIFO `full` and `empty` status indicators
- Synchronous reset
- Prevents writes when FIFO is full
- Prevents reads when FIFO is empty
- Verilog testbench for functional verification

## Design Specifications

|    Parameter   |        Description       |     Value     |
|----------------|--------------------------|---------------|
| FIFO Type      | Synchronous FIFO         | Single clock  |
| FIFO Depth     | Number of entries        | 16            |
| Data Width     | Width of each data entry | 8 bits        |
| Total Storage  | Data capacity            | 128 bits      |
| Reset          | Synchronous reset        | Active High   |
| Write Control  | `wr_en`                  | Active High   |
| Read Control   | `rd_en`                  | Active High   |
| Status Flags   | `full`, `empty`          | 1 bit each    |

## Block Diagram

The FIFO consists of the following main components:

- FIFO Memory – Stores the input data.
- Write Pointer – Tracks the memory location for the next write.
- Read Pointer – Tracks the memory location for the next read.
- Full Flag Logic – Detects when the FIFO is full.
- Empty Flag Logic – Detects when the FIFO is empty.
- Output Register – Stores the data retrieved during a read operation.

## RTL Design

The FIFO is implemented in Verilog HDL with configurable parameters:

```verilog
parameter DEPTH = 16;
parameter WIDTH = 8;
```

The design uses extended read and write pointers to distinguish between full and empty conditions when pointer positions wrap around.

### FIFO Status Logic

- **Empty:** Read pointer and write pointer are equal.
- **Full:** Pointer address bits are equal, but the wrap-around bits differ.

### Write Operation

When `wr_en` is asserted and the FIFO is not full, the input data is stored at the current write pointer location, and the write pointer advances.

### Read Operation

When `rd_en` is asserted and the FIFO is not empty, the stored data is transferred to the output, and the read pointer advances.

## Interface Signals

| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | FIFO clock |
| `rst` | Input | Active-high synchronous reset |
| `wr_en` | Input | Write enable |
| `rd_en` | Input | Read enable |
| `din` | Input | 8-bit input data |
| `dout` | Output | 8-bit output data |
| `full` | Output | Indicates FIFO is full |
| `empty` | Output | Indicates FIFO is empty |

## Verification

The design was verified using a Verilog testbench.

### Test Cases

1. **Reset Verification** – Checks the initial FIFO status after reset.
2. **Write Operation** – Writes 16 data values into the FIFO.
3. **Full Flag Verification** – Checks whether the `full` flag asserts after filling all 16 entries.
4. **Read Operation** – Reads stored data sequentially.
5. **Data Verification** – Compares output data with expected values.
6. **Empty Flag Verification** – Checks whether the `empty` flag asserts after all entries are read.

### Testbench Data

The testbench writes sequential values from **10 to 25** and verifies the read data against the expected sequence.

## Simulation Results

The waveform is used to observe:

- Clock and reset
- Write and read enable signals
- Input and output data
- FIFO full and empty status

The waveform and RTL schematic are included in the repository for reference.

## FPGA Implementation

| Tool / Parameter | Details |
|---|---|
| FPGA Tool | Intel Quartus Prime Lite Edition |
| Tool Version | 24.1 |
| FPGA Family | Cyclone 10 LP |
| Target Device | 10CL006YE144C8G |
| HDL | Verilog HDL |

## Project Files

| File | Description |
|---|---|
| `fifo.v` | FIFO RTL design |
| `sync_fifo_tb.v` | Verilog testbench |
| `waveform.png` | Simulation waveform |
| `rtl_schematic.png` | RTL schematic |

## Project Structure

```text
Synchronous-FIFO/
│
├── fifo.v
├── sync_fifo_tb.v
├── waveform.png
├── rtl_schematic.png
└── README.md
```

## Applications

Synchronous FIFO buffers are commonly used in:

- Data buffering
- Digital communication interfaces
- Processor and peripheral data transfer
- FPGA-based systems
- Temporary data storage between digital blocks

## Author

**Sakthimurugan V**

B.E. Electronics and Communication Engineering

---

*This project was developed as an RTL design and FPGA learning project using Verilog HDL and Intel Quartus Prime.*
