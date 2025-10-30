#!/bin/bash
echo "Lab 8 — Observing Consensus Rules — Demo"
echo "----------------------------------------"

# Copy first block file to tmp
mkdir -p ~/tmp
cp $HOME/.bitcoin/regtest/blocks/blk00000.dat ~/tmp/
echo "Block copied. You can manually edit a byte in ~/tmp/blk00000.dat to simulate corruption."

# Restart node
bitcoin-cli -regtest stop
sleep 5
mv ~/tmp/blk00000.dat $HOME/.bitcoin/regtest/blocks/blk00000.dat
bitcoind -regtest -daemon
echo "Bitcoin Core starting. Node restarted."

# Wait a few seconds for node to process the block
sleep 5

# Capture block rejection messages
echo "Checking for rejected blocks in debug log..."
grep -i "bad-blk\|badblock\|invalid" $HOME/.bitcoin/regtest/debug.log | tail -n 20

echo "Lab 8 demo complete."

