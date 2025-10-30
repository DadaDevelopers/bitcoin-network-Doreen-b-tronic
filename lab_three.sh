#!/bin/bash
OUTPUT_FILE="./Lab3_Outputs.txt"
NODE_DATADIR="$HOME/bitcoin-node1"
RPCPORT=18450
echo "" > $OUTPUT_FILE

echo "Lab 3 — Transaction Propagation and Mempool" | tee -a $OUTPUT_FILE

# Step 1: Send transaction
RECV_ADDR=$(bitcoin-cli -regtest -datadir=$NODE_DATADIR -rpcport=$RPCPORT getnewaddress)
TXID=$(bitcoin-cli -regtest -datadir=$NODE_DATADIR -rpcport=$RPCPORT sendtoaddress $RECV_ADDR 5.0)
echo "Sent 5 BTC to $RECV_ADDR. TXID: $TXID" | tee -a $OUTPUT_FILE

# Step 2: Check mempool
echo "Mempool info:" | tee -a $OUTPUT_FILE
bitcoin-cli -regtest -datadir=$NODE_DATADIR -rpcport=$RPCPORT getmempoolinfo | tee -a $OUTPUT_FILE
echo "Transactions in mempool:" | tee -a $OUTPUT_FILE
bitcoin-cli -regtest -datadir=$NODE_DATADIR -rpcport=$RPCPORT getrawmempool | jq '.' | tee -a $OUTPUT_FILE

# Step 3: Mine a block
MINING_ADDR=$(bitcoin-cli -regtest -datadir=$NODE_DATADIR -rpcport=$RPCPORT getnewaddress)
bitcoin-cli -regtest -datadir=$NODE_DATADIR -rpcport=$RPCPORT generatetoaddress 1 $MINING_ADDR
echo "Mined 1 block to confirm transaction." | tee -a $OUTPUT_FILE

# Step 4: Verify confirmation
echo "Transaction details:" | tee -a $OUTPUT_FILE
bitcoin-cli -regtest -datadir=$NODE_DATADIR -rpcport=$RPCPORT gettransaction $TXID | tee -a $OUTPUT_FILE

echo "Lab 3 complete. Output saved to $OUTPUT_FILE" | tee -a $OUTPUT_FILE

