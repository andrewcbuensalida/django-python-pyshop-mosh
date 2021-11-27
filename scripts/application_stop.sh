#!/bin/bash
#Stopping existing node servers
echo "Stopping any existing node server for real this time, not really"
pkill gunicorn
# dont really need this since pm2 automatically restarts on change because --watch flag
# pm2 delete books_node
# pm2 delete books_react

#add npm and node to path
# export NVM_DIR="$HOME/.nvm"	
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm	
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion (node is in path now)
