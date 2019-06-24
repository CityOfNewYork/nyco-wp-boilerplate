SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
BASE_PATH=$(dirname "$SCRIPT_PATH")

# source the environmental variables and scripts
source $BASE_PATH/config/bin.cfg
