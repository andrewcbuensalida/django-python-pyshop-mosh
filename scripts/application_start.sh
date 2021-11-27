#!/bin/bash

#give permission for everything in the express-app directory
sudo chmod -R 777 /home/ubuntu/books

#add npm and node to path
# export NVM_DIR="$HOME/.nvm"	
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm	
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion (node is in path now)

#navigate into our working directory where we have all our github files
cd /home/ubuntu/pyshop/

#install node modules
# initially do sudo npm ci, then after, do this
# npm i --production --prefer-offline
pip install -r requirements.txt
gunicorn pyshop.wsgi --daemon
echo "Finished installing server"


#start our node app in the background, exchanged app with script. dont need this because running pm2.
# node app.js > app.out.log 2> app.err.log < /dev/null & 
# echo "Finished running server"

#navigate into client directory. dont need to do this because build already contains node_modules
# cd /home/ubuntu/express-app/client
# npm ci
# npm run build
# # npm install -g serve
# echo "Finished installing client"
# serve -s build > app.out.log 2> app.err.log < /dev/null &