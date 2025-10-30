#!/bin/bash

echo "Lab 10 — Cleanup — Demo"
echo "------------------------"

# Stop Node1 (default datadir)
echo "Stopping Node1..."
bitcoin-cli -regtest stop

# Stop Node2 (custom datadir)
echo "Stopping Node2..."
bitcoin-cli -regtest -datadir=$HOME/bitcoin-node2 stop

# Optional: wait a few seconds to ensure nodes have stopped
sleep 3

# Optional: Remove temporary files
echo "Removing temporary files..."
rm -rf $HOME/bitcoin-node2
rm -rf $HOME/.bitcoin/regtest

echo "Cleanup complete."

