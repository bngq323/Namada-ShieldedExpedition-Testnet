#!/bin/bash

# Configuration
NODE="https://rpc-namada.kintsugi-nodes.com:443"

# Optionally predefine ADDRESS and PUBKEY here, if needed
# ADDRESS="your_address_here"
# PUBKEY="your_pubkey_here"

# Ask for user address if not set
if [ -z "$ADDRESS" ]; then
    echo "Please enter the address you want to vote from:"
    read ADDRESS
fi

# Ask for tpknam if not set
if [ -z "$PUBKEY" ]; then
    echo "Please enter your tpknam to be added in the memo field:"
    read PUBKEY
fi

# Get epoch
EPOCH=$(namadac epoch --node $NODE | grep 'Last committed epoch:' | awk '{print $4}')

echo "Current epoch is: $EPOCH. We'll vote only proposal in voting period that don't already have been voted."

IDS=$(curl -s https://namada-indexer.kintsugi-nodes.com/missing_votes/${ADDRESS}/${EPOCH} | jq '.[]')

# Check if IDS is empty
if [ -z "$IDS" ]; then
    echo "All proposals have been voted."
else
    for id in ${IDS[@]}; do 
        echo "Voting prop $id..."
        # Ask for the vote option
        echo "How do you want to vote for proposal $id? (yay/nay/abstain):"
        read VOTE_OPTION
        # Validate input
        while [[ "$VOTE_OPTION" != "yay" && "$VOTE_OPTION" != "nay" && "$VOTE_OPTION" != "abstain" ]]; do
            echo "Invalid vote. Please enter 'yay', 'nay', or 'abstain'."
            read VOTE_OPTION
        done
        # Execute voting command
        namadac vote-proposal --vote $VOTE_OPTION --proposal-id $id --address $ADDRESS --memo $PUBKEY --node $NODE
    done
fi

echo "Done."
curl -s http://127.0.0.1:26657/consensus_state  | jq '.result.round_state.height_vote_set[-2].prevotes_bit_array'


