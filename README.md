## Containers
 - PHP 8.4
 - Nginx
 - MySQL
 - Redis
 - Node
____
## System package requirements:
 - git
 - docker & docker-compose
 - make (Linux)
____

## Git
Git submodules feature is used   
(see: https://git-scm.com/book/en/v2/Git-Tools-Submodules)

You can clone this repository with `--recurse-submodules` option to have submodules initialized on cloning

`cd <project_dir>`    
`git clone --recurse-submodules git@github.com:DaniilMishkin/CSV-JSON-env.git .`  

Otherwise, use `git submodule init` command.  

Next step is to check out the branches. 
You can check out all submodules to 'main' branch with
    `git submodule foreach 'git checkout main'`  
Or you can check out each submodule separately running `git checkout <branch>` form submodule directory.  
Run `git submodule update --remote` to update submodules to the latest remote changes.  
Now you can work with submodule directories as if it was a standalone git repos.
____
## Configuration:
### Defining environment variables:   
`.env` file is used in `docker-compose` commands (as `--env-file` param)
- copy `.env.example` to `.env`
- edit `.env` - fill env variables with suitable values (see: 'Descriptions')

### Nginx
Choose one of the *.conf files from `conf/nginx/sites` and set its name to `NGINX_SITE_CONF` variable in the .env file    

You can create your own .conf file, copy it into `conf/nginx/sites` and describe it in `.env` file.

### HTTPS

Place certificate and key files into `ssl` dir.  
Use `dev-ssl.conf` (or similar) site config for Nginx.

## Deployment

### Windows\MacOs users note
Building steps are described using Linux 'make' console utility. You can study `Makefile` to get raw console commands. Feel free to transfer this commands to `.bat` (for Windows) or `.sh` (for MacOs) files.

### Building containers
 - `make build` - prod env building
 - `make build-dev` - dev env building
 - `make build-dev-nocache` - dev env building without cache usage

### Starting docker:
 - `make up` - start production env
 - `make up-dev` - start dev(local) env

### Stopping docker:
  - `make down`
____
## Descriptions

### Makefile commands description:
 - `make build` - builds docker containers (production env)
 - `make build-dev` - builds docker containers (dev\local env)
 - `make up` - start containers (production env)
 - `make up-dev` - start containers (dev\local env)
 - `make down` - stop containers
 - `make connect` - connect to PHP container as local user
 - `make connect-www` - connect to PHP container as 'www-data' user
 - `make connect-root` - connect to PHP container with superuser rights
 - `make connect-db` - connect to DB container (DB env vars must be set in local system)

### '.env' variables description:
 - `APP_URL` - Laravel env var value
 - `DB_DATABASE` - DB name (creates on container building)
 - `DB_USERNAME` - DB user (creates on container building)
 - `DB_PASSWORD` - DB password
 - `DB_ROOT_RASSWORD` - DB root password (optionally)
 - `PORT_PHP` - PHP\Nginx (backend) external port to map
 - `PORT_PHP_SSL` - PHP\Nginx (backend) external ssl port to map
 - `PORT_NODE` - Node\React.js (frontend) external port to map
 - `DEV_PORT_DB` - DB external port to map (dev\local env only)
 - `NGINX_SITE_CONF` - nginx site configuration file name (must be in `conf/nginx/sites` dir)

### Nginx configuration:
 - `conf/nginx/nginx.conf` - Nginx config file
 - `conf/nginx/sites` - sites config files storing dir
 - `conf/nginx/sites/default.conf` - default site config file
 - `conf/nginx/conf.d/default.conf` - Nginx feature‑specific config file
