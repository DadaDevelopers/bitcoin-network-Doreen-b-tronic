#!/bin/bash

# lab_two_nodes.sh
# Script to start a 2-node Bitcoin regtest network and save outputs

# Output file
OUTPUT_FILE="./Lab2_Outputs.txt"
echo "" > $OUTPUT_FILE

echo "Stopping any running bitcoind instances..." | tee -a $OUTPUT_FILE
pkill bitcoind 2>/dev/null || true
sleep 2

echo "Cleaning previous regtest data..." | tee -a $OUTPUT_FILE
rm -rf $HOME/bitcoin-node1/regtest/*
rm -rf $HOME/bitcoin-node2/regtest/*

# Node 1 configuration
NODE1_DIR="$HOME/bitcoin-node1"
NODE1_P2P=18444
NODE1_RPC=18450

# Node 2 configuration
NODE2_DIR="$HOME/bitcoin-node2"
NODE2_P2P=18446
NODE2_RPC=18451

echo "Starting Node 1..." | tee -a $OUTPUT_FILE
bitcoind -regtest -datadir=$NODE1_DIR -port=$NODE1_P2P -rpcport=$NODE1_RPC -daemon
sleep 3

echo "Starting Node 2..." | tee -a $OUTPUT_FILE
bitcoind -regtest -datadir=$NODE2_DIR -port=$NODE2_P2P -rpcport=$NODE2_RPC -daemon
sleep 3

# Check running nodes
echo "Checking running nodes..." | tee -a $OUTPUT_FILE
ps aux | grep '[b]itcoind' | tee -a $OUTPUT_FILE

# Show RPC cookie files
echo "Node1 cookie:" | tee -a $OUTPUT_FILE
ls $NODE1_DIR/regtest/.cookie 2>/dev/null | tee -a $OUTPUT_FILE

echo "Node2 cookie:" | tee -a $OUTPUT_FILE
ls $NODE2_DIR/regtest/.cookie 2>/dev/null | tee -a $OUTPUT_FILE

# Connect Node2 to Node1
echo "Connecting Node2 to Node1..." | tee -a $OUTPUT_FILE
bitcoin-cli -regtest -datadir=$NODE2_DIR -rpcport=$NODE2_RPC -rpcwait addnode 127.0.0.1:$NODE1_P2P onetry 2>&1 | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Save peer info for both nodes
echo "Node1 peer info:" | tee -a $OUTPUT_FILE
bitcoin-cli -regtest -datadir=$NODE1_DIR -rpcport=$NODE1_RPC -rpcwait getpeerinfo 2>&1 | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Node2 peer info:" | tee -a $OUTPUT_FILE
bitcoin-cli -regtest -datadir=$NODE2_DIR -rpcport=$NODE2_RPC -rpcwait getpeerinfo 2>&1 | tee -a $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

echo "Two-node regtest network is ready!" | tee -a $OUTPUT_FILE
echo "Node1 P2P: $NODE1_P2P, RPC: $NODE1_RPC" | tee -a $OUTPUT_FILE
echo "Node2 P2P: $NODE2_P2P, RPC: $NODE2_RPC" | tee -a $OUTPUT_FILE
echo "Lab2 network outputs saved to $OUTPUT_FILE" | tee -a $OUTPUT_FILE

