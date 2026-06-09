#!/bin/bash
echo "Compiling..."
iverilog -o uart_sim uart_tx.v uart_rx.v tb_uart.v

if [ $? -eq 0 ]; then
    echo "Running simulation..."
    vvp uart_sim
    echo "Opening waveform..."
    gtkwave uart_wave.vcd &
else
    echo "Compile failed. Check errors above."
fi
