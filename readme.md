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
had to create super user to be admin
un=admin
pw=1234
when migrating db, data from local disappears
have to collect all the static files with python3 manage.py collectstatic
ec2 wasnt letting me git pull because no user.name and user.email was set, so
git config --global user.name "andrewcbuensalida"
git config --global user.email "andrewcbuensalida@gmail.com"
