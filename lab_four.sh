#!/bin/bash

# Lab 4 — Compact Block Relay (BIP152) — Two Node Demo
# Ensure Node1 and Node2 are running before executing this script.

NODE1_DIR="$HOME/bitcoin-node1"
NODE2_DIR="$HOME/bitcoin-node2"
NODE1_RPC=18450
NODE2_RPC=18451
OUTPUT_FILE="./Lab4_Outputs.txt"

echo "Lab 4 — Compact Block Relay (BIP152) — Two Node Demo" > $OUTPUT_FILE
echo "Debug logs:" >> $OUTPUT_FILE
echo "Node1: $NODE1_DIR/regtest/debug.log" >> $OUTPUT_FILE
echo "Node2: $NODE2_DIR/regtest/debug.log" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# 1. Create wallets if they don't exist
bitcoin-cli -regtest -datadir=$NODE1_DIR -rpcport=$NODE1_RPC createwallet "wallet1" 2>/dev/null
bitcoin-cli -regtest -datadir=$NODE2_DIR -rpcport=$NODE2_RPC createwallet "wallet2" 2>/dev/null

# 2. Connect Node2 to Node1 (P2P)
bitcoin-cli -regtest -datadir=$NODE2_DIR -rpcport=$NODE2_RPC addnode "127.0.0.1:18444" "add"

# 3. Mine a block on Node1
ADDRESS=$(bitcoin-cli -regtest -datadir=$NODE1_DIR -rpcport=$NODE1_RPC -rpcwallet=wallet1 getnewaddress)
echo "Mined 1 block on Node1 to address $ADDRESS" | tee -a $OUTPUT_FILE
bitcoin-cli -regtest -datadir=$NODE1_DIR -rpcport=$NODE1_RPC -rpcwallet=wallet1 generatetoaddress 1 $ADDRESS >/dev/null

# 4. Wait for propagation
echo "Waiting 5 seconds for Node2 to receive compact block..." | tee -a $OUTPUT_FILE
sleep 5

# 5. Check compact block messages in debug logs
echo "" >> $OUTPUT_FILE
echo "Node1 compact block messages:" >> $OUTPUT_FILE
grep -E "sendcmpct|cmpctblock" $NODE1_DIR/regtest/debug.log >> $OUTPUT_FILE 2>/dev/null

echo "" >> $OUTPUT_FILE
echo "Node2 compact block messages:" >> $OUTPUT_FILE
grep -E "sendcmpct|cmpctblock" $NODE2_DIR/regtest/debug.log >> $OUTPUT_FILE 2>/dev/null

echo "" >> $OUTPUT_FILE
echo "Lab 4 complete. Output saved to $OUTPUT_FILE" | tee -a $OUTPUT_FILE

