#!/bin/bash

#add npm and node to path
# export NVM_DIR="$HOME/.nvm"	
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm	
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion (node is in path now)

#Stopping existing node servers
echo "Stopping any existing node server for real this time, not really"
# pkill node
# /home/ubuntu/.nvm/versions/node/v16.11.0/bin/pm2 stop doctordb_node > app.out.log 2> app.err.log < /dev/null &
# /home/ubuntu/.nvm/versions/node/v16.11.0/bin/pm2 delete doctordb_node > app.out.log 2> app.err.log < /dev/null &
