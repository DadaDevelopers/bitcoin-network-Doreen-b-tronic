#!/bin/bash

# lab_six.sh — Merkle Tree Exploration

OUTPUT="./Lab6_Outputs.txt"
NODE_DIR="$HOME/bitcoin-node1"
RPCPORT=18450

echo "Lab 6 — Merkle Tree Exploration" > $OUTPUT
echo "---------------------------------" >> $OUTPUT

# Step 1: Get the latest block hash
BLOCK_HASH=$(bitcoin-cli -regtest -datadir=$NODE_DIR -rpcport=$RPCPORT getbestblockhash)
echo "Latest block hash: $BLOCK_HASH" | tee -a $OUTPUT

# Step 2: Inspect block details
echo "Fetching block details..." | tee -a $OUTPUT
BLOCK_JSON=$(bitcoin-cli -regtest -datadir=$NODE_DIR -rpcport=$RPCPORT getblock $BLOCK_HASH true)
echo "$BLOCK_JSON" | tee -a $OUTPUT

# Extract merkleroot and txids
MERKLE_ROOT=$(echo "$BLOCK_JSON" | jq -r '.merkleroot')
TXIDS=$(echo "$BLOCK_JSON" | jq -r '.tx[]')

echo "Block merkleroot: $MERKLE_ROOT" | tee -a $OUTPUT
echo "Transactions in block:" | tee -a $OUTPUT
echo "$TXIDS" | tee -a $OUTPUT

# Step 3: Optional Merkle root verification
echo "Verifying Merkle root manually with Python..." | tee -a $OUTPUT
python3 - <<PYTHON >> $OUTPUT
import hashlib

def double_sha256(b):
    return hashlib.sha256(hashlib.sha256(b).digest()).digest()

txids = [bytes.fromhex(txid)[::-1] for txid in $TXIDS.split()]
while len(txids) > 1:
    if len(txids) % 2 == 1:
        txids.append(txids[-1])
    txids = [double_sha256(txids[i] + txids[i+1]) for i in range(0, len(txids), 2)]
merkle_root = txids[0][::-1].hex()
print("Calculated Merkle root:", merkle_root)
PYTHON

echo "Lab 6 complete. Output saved to $OUTPUT" | tee -a $OUTPUT

