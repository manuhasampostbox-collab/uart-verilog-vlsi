# UART Transceiver — VLSI Project 1

## Overview
A parameterised UART Transmitter and Receiver implemented in Verilog.
Demonstrates RTL design, FSM implementation, and functional verification
using a self-checking testbench.

**Simulation link:** https://edaplayground.com/x/k5cU

---

## Block Diagram

```
      tx_data [7:0]                        rx_data [7:0]
      tx_start                             rx_done
           |                                    ^
           v                                    |
     +----------+    tx_out (serial)      +----------+
     |  uart_tx |----------------------->|  uart_rx |
     +----------+     1-wire UART bus     +----------+
           |                                    |
          clk                                  clk
```

---

## UART Protocol

```
IDLE | START | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | STOP | IDLE
  1  |   0   | x  | x  | x  | x  | x  | x  | x  | x  |  1   |  1
```
- IDLE: Line stays HIGH
- START bit: Line pulled LOW for 1 bit period
- DATA bits: 8 bits sent LSB first
- STOP bit: Line pulled HIGH for 1 bit period

---

## File Structure

```
uart_verilog/
├── uart_tx.v    — Transmitter RTL (FSM: IDLE→START→DATA→STOP)
├── uart_rx.v    — Receiver RTL (detects start bit, samples data bits)
├── tb_uart.v    — Self-checking testbench
└── README.md    — This file
```

---

## Testbench Results

| Byte    | Sent | Received | Result  |
|---------|------|----------|---------|
| ASCII A | 0x41 | 0x41     | ✅ PASS |
| All 1s  | 0xFF | 0xFF     | ✅ PASS |
| Alt bits| 0x55 | 0x55     | ✅ PASS |

---

## Parameters

| Parameter     | Default | Description                        |
|--------------|---------|------------------------------------|
| CLKS_PER_BIT | 10      | Clock cycles per UART bit period   |

For 50MHz clock, 115200 baud: CLKS_PER_BIT = 434

---

## Tools Used
- Icarus Verilog 12.0
- EDA Playground (browser-based simulator)
- Verilog HDL

---

## Resume Bullet Point
Designed and verified a parameterised UART transceiver in Verilog;
implemented TX and RX state machines covering START, 8-bit DATA (LSB-first),
and STOP phases; self-checking testbench achieved 100% pass on 3 test vectors
using Icarus Verilog 12.0.
