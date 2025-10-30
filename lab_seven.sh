#!/bin/bash
# lab_seven.sh — Bloom Filters (BIP37) Demo

OUTPUT_FILE="./Lab7_Outputs.txt"
echo "Lab 7 — Bloom Filters (BIP37) — Demo" > "$OUTPUT_FILE"
echo "------------------------------------" >> "$OUTPUT_FILE"

echo "Checking if regtest nodes are running..." | tee -a "$OUTPUT_FILE"

# Node RPC info
NODE1_DATADIR="$HOME/bitcoin-node1"
NODE1_RPCPORT=18450
NODE2_DATADIR="$HOME/bitcoin-node2"
NODE2_RPCPORT=18451

# Test Node1 RPC
if bitcoin-cli -regtest -datadir="$NODE1_DATADIR" -rpcport=$NODE1_RPCPORT getblockchaininfo &>/dev/null; then
    echo "Node1 is running." | tee -a "$OUTPUT_FILE"
else
    echo "Node1 is NOT running. Start it first!" | tee -a "$OUTPUT_FILE"
    exit 1
fi

# Test Node2 RPC
if bitcoin-cli -regtest -datadir="$NODE2_DATADIR" -rpcport=$NODE2_RPCPORT getblockchaininfo &>/dev/null; then
    echo "Node2 is running." | tee -a "$OUTPUT_FILE"
else
    echo "Node2 is NOT running. Start it first!" | tee -a "$OUTPUT_FILE"
    exit 1
fi

echo "Disabling network activity on Node1..." | tee -a "$OUTPUT_FILE"
bitcoin-cli -regtest -datadir="$NODE1_DATADIR" -rpcport=$NODE1_RPCPORT setnetworkactive false &>> "$OUTPUT_FILE"

# Python Bloom filter
echo "Generating Bloom Filter in Python..." | tee -a "$OUTPUT_FILE"

# Create temporary venv if not exists
VENV_DIR="$HOME/venvs/pybloom"
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating Python virtual environment for pybloom-live..." | tee -a "$OUTPUT_FILE"
    mkdir -p "$HOME/venvs"
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
    pip install --upgrade pip &>/dev/null
    pip install pybloom-live &>/dev/null
else
    source "$VENV_DIR/bin/activate"
fi

# Run Bloom filter demo
python3 - <<EOF >> "$OUTPUT_FILE" 2>&1
from pybloom_live import BloomFilter
bf = BloomFilter(capacity=1000, error_rate=0.001)
bf.add('my_txid')
print("Bloom filter bitarray:", bf.bitarray)
EOF

deactivate

echo "Lab 7 complete. Output saved to $OUTPUT_FILE" | tee -a "$OUTPUT_FILE"

