#!/bin/bash

# lab_five.sh — Compact Block Filters (BIP157/158) Demo

OUTPUT="./Lab5_Outputs.txt"
NODE1_DIR="$HOME/bitcoin-node1"
RPCPORT1=18450

echo "Lab 5 — Compact Block Filters (BIP157/158) — Two Node Demo" > $OUTPUT
echo "--------------------------------------------" >> $OUTPUT

# Start Node1 with blockfilterindex
echo "Starting Node1 with blockfilterindex..." | tee -a $OUTPUT
bitcoind -regtest -datadir=$NODE1_DIR -rpcport=$RPCPORT1 -daemon -blockfilterindex=1
sleep 3

# Create wallet if it doesn't exist
WALLET_NAME="wallet1"
wallet_check=$(bitcoin-cli -regtest -datadir=$NODE1_DIR -rpcport=$RPCPORT1 listwallets | grep $WALLET_NAME)
if [ -z "$wallet_check" ]; then
    bitcoin-cli -regtest -datadir=$NODE1_DIR -rpcport=$RPCPORT1 createwallet $WALLET_NAME
else
    echo "Wallet $WALLET_NAME already exists." | tee -a $OUTPUT
fi

# Generate a new address to mine to
ADDRESS=$(bitcoin-cli -regtest -datadir=$NODE1_DIR -rpcport=$RPCPORT1 -rpcwallet=$WALLET_NAME getnewaddress)

# Mine 1 block
echo "Mining 1 block to address $ADDRESS..." | tee -a $OUTPUT
BLOCK_HASHES=$(bitcoin-cli -regtest -datadir=$NODE1_DIR -rpcport=$RPCPORT1 -rpcwallet=$WALLET_NAME generatetoaddress 1 $ADDRESS)
echo "$BLOCK_HASHES" | tee -a $OUTPUT

# Fetch block filter
BLOCK_HASH=$(echo $BLOCK_HASHES | jq -r '.[0]')
echo "Fetching block filter for block $BLOCK_HASH..." | tee -a $OUTPUT
BLOCK_FILTER=$(bitcoin-cli -regtest -datadir=$NODE1_DIR -rpcport=$RPCPORT1 getblockfilter $BLOCK_HASH)
echo "$BLOCK_FILTER" | tee -a $OUTPUT

# Optional decode simulation: just display filter data in hex
FILTER_DATA=$(echo $BLOCK_FILTER | jq -r '.filter')
echo "Simulated decode (filter data in hex):" | tee -a $OUTPUT
echo $FILTER_DATA | xxd -r -p | xxd | tee -a $OUTPUT

echo "Lab 5 complete. Output saved to $OUTPUT" | tee -a $OUTPUT

