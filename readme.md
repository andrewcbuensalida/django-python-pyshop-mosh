from https://www.youtube.com/watch?v=_uQrJ0TkZlc&t=15s
i think i needed to restart the server so it could save the orange product
ctrl + alt + l is to reformat code like prettier
to run server, python manage.py runserver
pip freeze > requirements.txt to save dependencies
pip install -r requirements.txt to install dependencies
have to setup a venv by sudo apt install python3-venv
then python3 -m venv venv
https://www.youtube.com/watch?v=Sa_kQheCnds&t=43s
then activate it with source venv/bin/activate
venv is its an environment to contain the program, to not interfere with other programs
in pyshop/settings, allowed host has to be ALLOWED_HOSTS = ['pyshop.anhonestobserver.com']
nginx has to proxy to localhost:8000 not localhost:8000/products
had to create super user to be admin, python manage.py createsuperuser
un=admin
pw=1234
when migrating db, data from local disappears
have to collect all the static files with python3 manage.py collectstatic
ec2 wasnt letting me git pull because no user.name and user.email was set, so
git config --global user.name "andrewcbuensalida"
git config --global user.email "andrewcbuensalida@gmail.com"
if you cant see a remote branch, git remote update
to fix git refusing to merge unrelated histories when pulling from github into ec2,
git pull origin branchname --allow-unrelated-histories

trying this for nginx
server {
#root /home/ubuntu/starwars;
#index index.html index.htm index.nginx-debian.html;
server_name pyshop.anhonestobserver.com www.pyshop.anhonestobserver.com;

        location /static/ {
                alias /home/ubuntu/pyshop/static/;
        }

        location / {
                proxy_pass http://0.0.0.0:8000/products/;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
        }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/doctordb.anhonestobserver.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/doctordb.anhonestobserver.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

doing the uwsgi method https://www.youtube.com/watch?v=ZpR1W-NWnp4
to run server, adding & makes it run in background, uwsgi --http :8000 --module pyshop.wsgi &
need htop to kill it if in background, https://www.digitalocean.com/community/tutorials/how-to-deploy-python-wsgi-applications-using-uwsgi-web-server-with-nginx

working from here, but continuing on with the tony teaches tech video, changed the nginx, added uwsgi_params file, do uwsgi --socket pyshop.sock --module pyshop.wsgi --chmod-socket=666
now its not working again.
// to kill a process, ps -aux to search all processes, then kill 9 <pid>
next time do gunicorn?

yes gunicorn works. just install then gunicorn pyshop.wsgi --daemon to run in background
it's NOT hot reload
to kill, pkill gunicorn

now trying code pipeline
buildspec is for code build
appspec is for code deploy
didnt work, so workflow would be push master to github, then ssh into ec2, then pull. then pkill gunicorn then gunicorn pyshop.wsgi --daemon

about git
there are the local branches, then tracking branches which are proxies for remote(upstream) branches but saved on local machine, when a remote branch is edited, these tracking branches arent automatically updated. youd have to do git remote update to update from all remote repos. git fetch is basically git remote update but just for one remote repo. git fetch --all fetches from all remotes so i guess its like git remote update. when on a local branch linked to a tracking branch, doing git pull automatically knows which remote repo to pull from, then merges the remote with the local branch.
when on master branch, then merge with feature branch, the master branch gets to updates of the feature branch.
to check what local branches are tracking what upstream branches, git branch -vv
git branch -a to see local and remote branches
to make a local branch track a remote branch, checkout that local branch, then git checkout --track remotes/pyshop/<branch>
origin is the remote github url
rebase puts all the changes of another branch and sticks it in where it first diverged with your branch.
git push origin master to push new commits of the master branch to github
git push origin --all to push new commits of all branches to github

with nginx proxypass to :8000/products/, it works. the problem is, if you just go to pyshop.anhonestobserver.com/admin, it wont be found. somehow have to tell gunicorn to redirect to products. or do a contrived nginx thing where / redirects to
:8000/products/ and /admin redirects to :8000/admin/

sudo nano /etc/nginx/sites-available/pyshop.anhonestobserver.com.conf
