PYSHOP
from https://www.youtube.com/watch?v=_uQrJ0TkZlc&t=15s
i think i needed to restart the server so it could save the orange product
ctrl + alt + l is to reformat code like prettier
to run server, python manage.py runserver //this is for development only they say
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
there are the local branches, then tracking branches which are proxies for remote(upstream) branches but saved on local machine,
when a remote branch is edited, these tracking branches arent automatically updated. youd have to do git remote update to update from all remote repos.
git fetch is basically git remote update but just for one remote repo. git fetch --all fetches from all remotes so i guess its like git remote update. when on a local branch linked to a tracking branch, doing git pull automatically knows which remote repo to pull from, then merges the remote with the local branch.
when on master branch, then merge with feature branch, the master branch gets to updates of the feature branch.
to check what local branches are tracking what upstream branches, git branch -vv
git branch -a to see local and remote branches
to make a local branch track a remote branch, checkout that local branch, then git checkout --track remotes/pyshop/<branch>
origin is the remote github url
rebase puts all the changes of another branch(usually master) and sticks it in where it first diverged with your branch(usually feature). in other words, all the changes in the
current checked out head branch will be put in front of the latest commit of the master branch.
if theres any conflicts, it wont let you merge. youd have to choose to accept current change or incoming change, then itll merge. if there are conflicts on a rebase, itll do the same, but
you can abort the whole rebase or ignore the conflicts, not sure about this.
fast forward merge is when youre on featurebranch and do git merge master, and feature didnt have any commits but the master had commits, master and feature will have the same history.
in other words, the new commits of master will be added to the history of feature branch.
if feature has commits, and master has commits, so they diverged, and while you're on feature and do git merge master, as long as there are no conflicts, like different files changed,
then commits of master will be applied to feature, meaning history will be incorporated by date, like the two branches are squashed together,
and a new merge commit will be created. then if you checkout master, it wont know it was squashed, it will be behind
the feature branch, meaning it won't see the changes that feature made or the new merge. you would have to git merge feature to make master and feature synchornized.
head is whatever you're looking at right now. whatevers checked out.
git push origin master to push new commits of the master branch to github
git push origin --all to push new commits of all branches to github
git checkout master, then git merge feaure-branch seems to put all the commits of the feature branch after the commits of the master.
the git logs of merge and rebase look the same.
pull requests are proposed merges to a branch in the base repo (usually the repo that was forked), or in the head repo(usually forked version of the base repo).
pushing is uploading changes to your github.
make sure windows credential manager(github and vs code), vs code(bottom left), gh cli( gh auth status, gh auth login/logout), and gh is logged in to the correct account.
if it says no write access, or permission denied. try killing terminal.
keep in mind git reset --hard <good commit>. this turns the head into the good commit, with that history.
control+s puts changes in changes status. then git add puts those changes in staged status. then git commit commits those staged changes. need to do the steps in sequence.
in other words, if you skip a step, the step won't automatically do the skipped step for you, and nothing will be commited or staged.
when youre working on a feature, but dont want to commit yet, and you want to check a different branch, then git stash. then you can checkout a different branch. then go back to the
branch where you stashed, then git stash pop. but then if you create a file, then git stash, then checkout a different branch, that new file will still be visible.
have to do git stash --all to stash even untracked newly created files, but then this stashes the node_modules. or have to stage the new file before stashing, better.

git wokflow for collaborating on github should be, there's two methods:

A. fork a gh repo to your gh account. git clone that repo with git clone https://github.com/andrewlove219/doctor-google.git or whatever url the forked repo is so it gets downloaded
to local machine. create a feature branch with git checkout -b <myfeaturebranch>. make changes then commit. git branch -a will show the remote branches. before pushing, checkout master
to see if anyone else made changes to it. do this with git pull origin master. if it's up to date, then can push the feature branch. if master is not up to date, then create a new
branch based on the feature branch, and merge with the new local master to see if new feature still works. refactor when necessary. now setup so that the current branch is linked to
an upstream remote branch with git push -u origin <featurebranch>. -u could be replaced with --set-upstream. this will push that local branch to gh.
subsequent pushes could just be git push. could also locally merge with master with git checkout master then git merge featurebranch. then push that master branch.
on gh, create a pull request. others will review your code and give comments. owner(the original admin of the base branch) could do gh pr
checkout my-feature-branch while he is on his local repo folder. this will create the my-feature-branch on his local. now he can test it on his local. he can push that and
itll update the fork repo featurebranch. contributor could make the change and push again also. when no more change is needed, admin will approve the pull request and it will
merge the fork repo feature branch to base repo master. it's pretty flexible, could do fork repo feature branch to fork repo master branch, to base repo master branch, etc.
just dont merge if the current branch you're on has questionable code. git revert <commit you want to undo> makes a new commit with the commit undone, other commits, even if they
were commited after the undone commit, will remain. have to revert one by one, or a range. if a commit is based on the commit you want to revert, like if a commit creates a file,
then the next commit modifies that file, then you try to revert the first commit, it wont happen.
git reset --hard <commit id> will make the current head to that commit and no more history of other subsequent commits.
then if you want to push, do git push -f to force it.
if checking out a previous commit, then making a new commit, then checking out any branch, it will leave that new commit not connected. if you want to keep it, create a new branch withit
with git branch <new-branch-name> <then the commit id>

B. second is without creating the fork. owner should invite a contributor, contributor accepts by going to base repo and accepting, then contributor clones, creates a new branch,
pushes it with git push --set-upstream origin <feature-branch>.

with nginx proxypass to :8000/products/, it works. the problem is, if you just go to pyshop.anhonestobserver.com/admin, it wont be found. somehow have to tell gunicorn to redirect to products. or do a contrived nginx thing where / redirects to
:8000/products/ and /admin redirects to :8000/admin/

sudo nano /etc/nginx/sites-available/pyshop.anhonestobserver.com.conf

--------------------------------------
now migrating to ec2 t2 micro.
nginx config:

sudo nano /etc/nginx/sites-available/pyshop.anhonestobserver.com.conf

nginx now looks like
server {
        listen 80;
        server_name pyshop.anhonestobserver.com www.pyshop.anhonestobserver.com;
        location /static {
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
        location /admin {
                proxy_pass http://0.0.0.0:8000/admin;  
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';  
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade; 
        }
}


careful with the spacings, when copy pasting, seems to add uneeded spaces that will error. try copy pasting into a notepad file first then into ec2.
have to do the sim link thing sudo ln -s /etc/nginx/sites-available/pyshop.anhonestobserver.com.conf /etc/nginx/sites-enabled/
sudo systemctl reload nginx to make sure it's working

for first time installing certbot, sudo snap install core; sudo snap refresh core
then sudo apt-get remove certbot
then sudo snap install --classic certbot

then everytime you add an app,
sudo certbot --nginx


to setup django app:
install python with : sudo apt install python3-pip
pip install -r requirements.txt to install dependencies
create database with : python3 manage.py migrate
create user for the database: python3 manage.py createsuperuser
yes gunicorn works. just install with $ sudo apt-get install gunicorn
then gunicorn pyshop.wsgi --daemon to run in background
// to kill a process, ps -aux to search all processes, then kill 9 <pid>
it's NOT hot reload
to kill, pkill gunicorn
workflow would be push master to github, then ssh into ec2, then git pull, then pip install -r requirements.txt, then pkill gunicorn then gunicorn pyshop.wsgi --daemon

