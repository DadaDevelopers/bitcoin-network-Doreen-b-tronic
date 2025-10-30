#!/bin/bash

echo "Lab 9 — Visualizing Peer Connections — Demo"
echo "------------------------------------------"

# Optional: specify datadir if using custom nodes
DATADIR1="$HOME/bitcoin-node1"
DATADIR2="$HOME/bitcoin-node2"
RPCPORT1=18450
RPCPORT2=18451

echo "Fetching peer info for Node1..."
bitcoin-cli -regtest -datadir=$DATADIR1 -rpcport=$RPCPORT1 getpeerinfo | jq '[.[] | {addr, subver, inbound}]'

echo
echo "Fetching peer info for Node2..."
bitcoin-cli -regtest -datadir=$DATADIR2 -rpcport=$RPCPORT2 getpeerinfo | jq '[.[] | {addr, subver, inbound}]'

echo
echo "Network info for Node1:"
bitcoin-cli -regtest -datadir=$DATADIR1 -rpcport=$RPCPORT1 getnetworkinfo

echo
echo "Network info for Node2:"
bitcoin-cli -regtest -datadir=$DATADIR2 -rpcport=$RPCPORT2 getnetworkinfo

echo
echo "Lab 9 demo complete."

