# How this works
There are a few components involved in this flask web app:
- Python virtual environment
- Gunicorn
- systemd
- Unix socket (connects to nginx)
- Nginx

~~~
                         Internet
                            │
                            │ HTTP :80
                            ▼
                     ┌─────────────┐
                     │    Nginx    │
                     │   :80       │
                     └──────┬──────┘
                            │
                            │ Unix socket
                            │ /run/gunicorn.sock
                            ▼
                     ┌─────────────┐
                     │  Gunicorn   │
                     │             │
                     │  3 workers  │
                     └──────┬──────┘
                            │
                            ▼
                     ┌─────────────┐
                     │    Flask    │
                     │    app.py   │
                     └─────────────┘
~~~

# Setting up the environment
## 1. Creating the app directory
### a. Create path for website and chuck it in there 
~~~
sudo mkdir -p /var/www/app
~~~
You could just git clone it in `/var/www`, in which case the path would be `/var/www/shiny-palm-tree/website/`

### b. Give the webste the proper permissions it needs
~~~
sudo chown -R www-data:www-data /var/www/app
~~~

### c. Create and give proper permissions for the .gunicorn directory
~~~
mkdir /var/www/.gunicorn
chown www-data:www-data /var/www/.gunicorn
~~~

## 2. Create the python virtual environment
### a. Ensure you are in the website directory
~~~
python3 -m venv venv
~~~

### b. Activate it
~~~
source venv/bin/activate
~~~

### c. Install requirements
~~~
pip install -r requirements.txt
~~~

## 3. Copy the systemd service and socket files over and load them
### a. Copy systemd file
~~~
/path/to/repo/system-files/gunicord.* /etc/systemd/system/
~~~

### b. Reload systemd and start systemd services
~~~
sudo systemctl daemon reload
sudo systemctl enable --now gunicorn.socket
sudo systemclt enable --now gunicord.service
~~~
This hosts gunicorn on a system socket so that nginx can connect to it.

## 4. Configure Nginx
### a. Install nginx
~~~
sudo apt install nginx
~~~

### b. Replace /etc/nginx/nginx.conf
~~~
cp /path/to/repo/system-files/nginx.conf /etc/nginx/nginx.conf
~~~
You can run `nginx -t` to ensure that the config file works

### c. Replace default nginx file
~~~
cp /path/to/repo/system-files/default /etc/nginx/sites-available/default
~~~


### d. Reload nginx
~~~
sudo systemctl reload nginx
~~~


