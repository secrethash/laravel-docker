# Docker for Laravel on Local

Docker Setup for Laravel applications for ***local development*** also supporting multi-tenancy using sub-domains (for ex: foo.localhost, bar.localhost). Tested with [Tenancy for Laravel](https://tenancyforlaravel.com/).

> ***WARNING:*** This setup is not suitable for production.

### Services Included:

- **PHP-FPM**
- **NGINX** (server)
- **TRAEFIK** (reverse proxy)
- **SUPERVISOR** (process monitor)
- **MySQL** (database)
- **Redis** (key value database)
- **Memcached** (caching)
- **Elasticsearch** (search driver for laravel scout)
- **Mailhog** (email testing)
- **Minio** (S3 on Local)

## Steps to setup

### Initial Setup

1. Use this as a template Repository.
2. Clone the created project from the template.
3. Create a `backend` and `frontend` folder inside the `workspace` directory.
4. Copy this project's example.env as .env & update as required.
5. Clone the backend (laravel) app in your `backend` folder and frontend app in your `frontend` folder.
    - Example: clone `backend` using ssh (on this project's root)
    ```sh
    git clone git@github.com:organization/backend-repo.git ./workspace/backend
    ```
    - Example: clone `frontend` using ssh (on this project's root)
    ```sh
    git clone git@github.com:organization/frontend-repo.git ./workspace/frontend
    ```
6. Edit the backend & frontend app's `.env` files according to your needs.
7. Run the docker up command with build & detached flag:
  ```sh
  docker compose up -d --build --remove-orphans
  ```
8. Enter the core container to:
    - `composer install`
    - setup laravel using:
        - `php artisan key:generate`
        - `php artisan migrate --seed`
    - `yarn`
```sh
docker exec -it shld-core sh
```
9. Re-create the Supervisor Worker:
```sh
docker compose stop supervisor
docker compose rm supervisor
docker compose up -d
```

## Conatiners

```sh
[+] Running 10/10
 ✔ Network laravel-docker_shld   Created
---- ⚓ Conatiners 👇 -----------------------
 ✔ Container shld-memcached      Started
 ✔ Container shld-elasticsearch  Started
 ✔ Container shld-redis          Started
 ✔ Container shld-db             Started
 ✔ Container shld-mailhog        Started
 ✔ Container shld-minio          Started
 ✔ Container shld-reverse-proxy  Started
 ✔ Container shld-core           Started
 ✔ Container shld-engine         Started
 ✔ Container shld-worker         Started
```

## Starting and stopping

After the initial setup:

1. To bring the containers down you just need to run the following command:

```sh
docker compose down
```

2. If you want to bring them up, just run:

```sh
docker compose up -d --remove-orphans
```

3. To enter the core container's shell to run `composer`, `yarn` & `php artisan` based commands:

```sh
docker exec -it shld-core sh
```

## Access URLs

1. **Application:**
    - URL Scheme: `{APP_HOST}:{FORWARD_TRAEFIK_PORT}`
    - Example: `http://localhost`

2. **Minio Console:**
    - URL Scheme: `{MINIO_HOST}:{FORWARD_MINIO_CONSOLE_PORT}`
    - Example: `http://localhost:8900`

3. **MailHog Dashboard:**
    - URL Scheme: `{APP_HOST}:{FORWARD_MAILHOG_DASHBOARD_PORT}`
    - Example: `http://localhost:8025`

4. **Traefik Dashboard:**
    - URL Scheme: `{TRAEFIK_DASH}:{FORWARD_TRAEFIK_DASH_PORT}/dashboard`
    - Example: `http://localhost:8080/dashboard`


## Use `shld` Command (linux)

> **Note:** This also works with WSL linux. This might also work on MacOS (not tested)

Instead of going inside the container interactively every time, then running the desired command, You can use command `shld` to run commands directly:

```sh
shld core artisan about
# OR
shld core composer install
# OR
shld core yarn
```

Where `core` is the container (i.e. `shld-core`) followed by the command that you want to run on that container.

To achive this you need to setup the shld command first:

1. make `shld_command.sh` executable

```sh
chmod +x ./shld_command.sh
```

2. Add source to the bash (if using zsh or anything other than bash, replace the `.bashrc` with the correct one):
```sh
echo -e "\n# SHLD Command\nsource $PWD/shld_command.sh" >> ~/.bashrc
source ~/.bashrc
```

### Commands:

To run these basic commands (below) inside the `core` container you don't need to specify `core` in the command, they can be executed directly. To run them in a different container, you will have to specify a container.

#### Example (on core container):

```sh
shld core artisan about
```

So this would also work, and acts as a shorthand:

```sh
shld artisan about
```

#### Example (on supervisor container)

> Note: Although it's an option, it won't be needed for most use cases.

```sh
shld worker artisan about
```

1. Docker compose up

Proxied: `docker compose up -d --build --remove-orphans`

```sh
shld up
```

2. Docker compose down

Proxied: `docker compose down`

```sh
shld down
```

3. PHP Artisan Commands

Proxied: `docker compose -it exec shld-core php artisan about`

```sh
shld artisan about
```

4. Composer Commands

Proxied: `docker compose -it exec shld-core composer install`

```sh
shld composer install
```

5. Yarn Commands

Proxied: `docker compose -it exec shld-core yarn`

```sh
shld yarn
```

Proxied: `docker compose -it exec shld-core yarn dev`

```sh
shld yarn dev
```

> **Note:** The supervisor (worker) container already keep an instance on `yarn dev` running. You can control that in `.env` config.

6. PHP Unit

Proxied: `docker compose -it exec shld-core ./vendor/bin/phpunit`

```sh
shld unit
```

OR

```sh
shld phpunit
```

7. Pint

Proxied: `docker compose -it exec shld-core ./vendor/bin/pint`

```sh
shld pint
```