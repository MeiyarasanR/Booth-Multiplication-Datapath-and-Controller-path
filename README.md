# Booth Multiplier (16-bit Signed) – Verilog Implementation

## 📌 Overview
This repository contains a **fully verified 16-bit signed Booth Multiplier** implemented in **Verilog HDL** using a **Controller + Datapath** architecture.  
The design correctly handles **all signed edge cases**, including the critical **–32768 (0x8000)** operand scenario, and has been validated with an extensive **self-checking testbench**.

This project is **placement-ready** and demonstrates strong understanding of:
- Sequential arithmetic hardware
- FSM-based control logic
- Signed arithmetic corner cases
- RTL verification using testbenches

---

## ✨ Key Features
- ✅ **Signed 16-bit × 16-bit multiplication**
- ✅ **Booth’s Algorithm** (radix-2)
- ✅ **Controller + Datapath separation**
- ✅ **17-bit internal arithmetic** to prevent overflow
- ✅ **Special handling for –32768 (0x8000)**
- ✅ **Self-checking testbench**
- ✅ **Synthesizable & simulation-tested**
- ✅ Works correctly in **Xilinx Vivado**

---

## 🧠 Architecture Overview

### Datapath Components
- **Accumulator (A)** – 16-bit arithmetic register
- **Multiplier Register (Q)** – 16-bit shift register
- **Extra Flip-Flop (Q-1)** – Booth decision bit
- **Multiplicand Register (M)** – 16-bit PIPO register
- **17-bit Add/Sub Unit** – Signed arithmetic
- **5-bit Counter** – Controls 16 iterations

### Controller
- FSM-based controller
- Generates control signals:
  - `ldA, ldQ, ldM`
  - `clrA, clrQ, clrDff`
  - `sftA, sftQ`
  - `addsub`
  - `decr, ldCount`
  - `done`

---

## 🧮 Booth Algorithm (Radix-2)

| Q0 | Q-1 | Operation |
|----|-----|----------|
| 0  | 0   | Shift |
| 1  | 1   | Shift |
| 0  | 1   | A = A + M |
| 1  | 0   | A = A − M |

After each operation:
- Arithmetic right shift of `{A, Q, Q-1}`
- Counter decremented
- Process repeats for **16 cycles**

---

## ⚠️ Special Case: –32768 Handling
The value **–32768 (0x8000)** cannot be negated in 16-bit two’s complement.


<img width="1019" height="536" alt="image" src="https://github.com/user-attachments/assets/5bbdb24d-b7d7-48b2-bc1d-32b814ca73db" />
<img width="487" height="539" alt="image" src="https://github.com/user-attachments/assets/9cdf0bd7-fca5-43fd-93ce-a7d1f52e49aa" />

### Solution Used:
- Detect if either input equals `16'sh8000`
- Force **–32768** to be used as the **multiplier (Q)**
- Prevents incorrect overflow behavior
- Ensures correct 32-bit result

---

## ▶️ How to Simulate (Vivado)

1. Open **Xilinx Vivado**
2. Create a new RTL project
3. Add:
   - `Booth_Multiplier.v`
   - `Booth_Multiplier_TB.v`
4. Set `Booth_Multiplier_TB` as **top module**
5. Run **Behavioral Simulation**
6. Observe console output for PASS / FAIL results

---

## 🧪 Testbench Highlights
- ✔ Automatic result verification
- ✔ Compares DUT output with `expected = A * B`
- ✔ Covers:
  - Positive numbers
  - Negative numbers
  - Mixed signs
  - Large values
  - **Critical edge cases**

### Tested Edge Cases
- `32767 × 1`
- `1 × –32768`
- `–1 × –32768`
- `–32768 × 2`
- `–32768 × –1`

---

## 📊 Output
- Output is **32-bit signed**
- Final result = `{A, Q}` after Booth completion
- `done` signal indicates completion

---

## 🎯 Skills Demonstrated
- Digital Arithmetic Design
- Finite State Machines (FSM)
- Signed Two’s Complement Arithmetic
- RTL Coding (Verilog)
- Hardware Verification
- Corner Case Handling
- Placement-Oriented Project Design

---

## 🚀 Suitable For
- VLSI Placement Projects
- Digital Design Interviews
- Booth Algorithm Demonstration
- Controller–Datapath Based Designs
- RTL Design Portfolios

---

## 📌 Author
**Meiyarasan R**  
Electronics & Communication Engineering  
Focus Area: **Digital VLSI | Processor Design | RTL**

---

## ⭐ If you find this useful
Give the repository a ⭐ and feel free to fork or extend it!

