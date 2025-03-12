# MIPS32 Single-Cycle Processor

## Overview
This project implements a **MIPS32 Single-Cycle Processor** in VHDL, designed to execute instructions in a single clock cycle. The processor consists of multiple interconnected components that handle instruction fetching, decoding, execution, memory access, and write-back stages.

## Components

### 1. **Instruction Fetch (iFetch)**
   - Retrieves instructions from memory.
   - Calculates the next program counter (PC).
   - Supports jump and branch operations.

### 2. **Instruction Decode (ID)**
   - Decodes the fetched instruction.
   - Reads registers from the register file.
   - Performs sign extension.

### 3. **Control Unit (UC)**
   - Generates control signals based on instruction opcode.
   - Determines operation modes (e.g., ALU operation, memory access, branching).

### 4. **Execution Unit (EX)**
   - Executes arithmetic and logic operations via the ALU.
   - Calculates branch target addresses.

### 5. **Memory Access (MEM)**
   - Handles memory read and write operations.
   
### 6. **Write Back (WB)**
   - Selects the final result to be written back into the register file.

### 7. **Multiplexer and Display Components**
   - `MPG`: Generates enable signals for button presses.
   - `SSD`: Displays data on a seven-segment display.

## Features
- **Supports basic MIPS instructions**: arithmetic, logical, memory access, and control flow.
- **Implements hazard-free single-cycle execution**.
- **Displays internal signals using LEDs and a seven-segment display**.

## Usage
- **Switches (`sw`)** select different internal values for display.
- **Buttons (`btn`)** act as control inputs (e.g., reset, enable execution).
- **LEDs (`led`)** indicate control signal states.
- **7-Segment Display (`SSD`)** shows selected processor data.

## File Structure
- `test_env.vhd` - Top-level entity interconnecting all components.
- `MPG.vhd` - Mono-pulse generator for button presses.
- `SSD.vhd` - Seven-segment display driver.
- `iFetch.vhd` - Instruction fetch unit.
- `ID.vhd` - Instruction decode unit.
- `UC.vhd` - Control unit.
- `EX.vhd` - Execution unit.
- `MEM.vhd` - Memory unit.
