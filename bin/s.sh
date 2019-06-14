#!/bin/sh

# Shorthand for using SSH to remote into WP Engine instances
# Usage
# bin/s.sh <instance>

INSTANCE=$1

COMMAND="ssh ${INSTANCE}@${INSTANCE}.ssh.wpengine.net"

eval $COMMAND
