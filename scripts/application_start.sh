#!/bin/bash

#give permission for everything in the express-app directory
sudo chmod -R 777 /home/ubuntu/pyshop

#add npm and node to path
# export NVM_DIR="$HOME/.nvm"	
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm	
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion (node is in path now)

#navigate into client directory
# cd /home/ubuntu/doctordb/client
# npm i --production --prefer-offline
# npm run build
# echo "Finished installing client"
# serve -s build > app.out.log 2> app.err.log < /dev/null &

#navigate into our working directory where we have all our github files
cd /home/ubuntu/pyshop

#install node modules
# npm i --production --prefer-offline
pip install -r requirements.txt
echo "Finished installing server"

#start our node app in the background, exchanged app with script
# node app.js > app.out.log 2> app.err.log < /dev/null & 
# /home/ubuntu/.nvm/versions/node/v16.11.0/bin/pm2 restart doctordb_node > app.out.log 2> app.err.log < /dev/null &
# echo "Finished running server"


