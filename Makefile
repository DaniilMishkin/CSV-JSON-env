build:
	docker compose --env-file=".env" build --no-cache --build-arg APP_ENV="production" --build-arg UID="$(shell id -u)" --build-arg GID="$(shell id -g)"

build-dev-nocache:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file=".env" build --no-cache --build-arg APP_ENV="local" --build-arg UID="$(shell id -u)" --build-arg GID="$(shell id -g)"

build-dev:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file=".env" build --build-arg APP_ENV="local" --build-arg UID="$(shell id -u)" --build-arg GID="$(shell id -g)"

build-stage:
	docker compose -f docker-compose.yml -f docker-compose.stage.yml --env-file=".env" build --build-arg APP_ENV="local" --build-arg UID="$(shell id -u)" --build-arg GID="$(shell id -g)"

build-node:
	docker compose -f docker-compose.yml --env-file=".env" build --build-arg UID="$(shell id -u)" --build-arg GID="$(shell id -g)" node
	docker compose -f docker-compose.yml run --no-deps --remove-orphans node

build-node-dev:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file=".env" build --build-arg UID="$(shell id -u)" --build-arg GID="$(shell id -g)" node

up:
	docker compose --env-file=".env" up -d

up-dev:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file=".env" up -d

up-stage:
	docker compose -f docker-compose.yml -f docker-compose.stage.yml --env-file=".env" up -d

up-node:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file=".env" up node -d

down:
	docker compose  -f docker-compose.yml -f docker-compose.dev.yml --env-file=".env" down

connect:
	@docker exec -it -u="$(shell id -u):$(shell id -g)" bt_crm-php /bin/bash

connect-root:
	@docker exec -it bt_crm-php /bin/bash

connect-db:
	#docker compose --env-file=".env" exec db-mysql sh -c "mysql -u${DB_USERNAME} -p${DB_PASSWORD} -D${DB_DATABASE}"
	docker compose --env-file=".env" exec db-mysql sh -c 'echo "mysql -u$${MYSQL_USER} -p$${MYSQL_PASSWORD} -D$${MYSQL_DATABASE}" > /connect.sh && chmod 0777 /connect.sh'
	docker compose --env-file=".env" exec db-mysql sh -c "/connect.sh"

connect-node:
	@docker exec -it -u="$(shell id -u):$(shell id -g)" bt_crm-node /bin/bash

deploy: run-maintenance-on update-src run-php-update run-php-refresh-permissions run-maintenance-off build-node

update-src:
	git submodule update --remote src

run-maintenance-on:
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-fpm sh -c "php artisan down --refresh=15"

run-maintenance-off:
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-fpm sh -c "php artisan up"

run-php-update:
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-fpm sh -c "composer install --no-dev --no-interaction --optimize-autoloader"
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-fpm sh -c "php artisan config:cache"
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-fpm sh -c "php artisan route:cache"
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-fpm sh -c "php artisan migrate -n"

run-php-refresh-permissions:
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-fpm sh -c "php artisan permission:cache-reset"
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-fpm sh -c "php artisan db:seed --class=RolePermissionsSeeder"

run-reverb-restart:
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-reverb sh -c "php artisan reverb:restart"

run-node-update:
	docker compose exec -u="$(shell id -u):$(shell id -g)" node sh -c "yarn install"

run-dev-dbfresh:
	docker compose exec -u="$(shell id -u):$(shell id -g)" php-fpm sh -c "php artisan migrate:fresh --seed --seeder=DevDatabaseSeeder"

run-php-schedule:
	docker compose --env-file=".env" run --no-deps --remove-orphans php-schedule

run-dev-test:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file=".env" run php-test

init-db-testing:
	docker compose --env-file=".env" exec db-mysql sh -c 'echo "CREATE DATABASE IF NOT EXISTS $${MYSQL_DATABASE_TESTING};create user $${MYSQL_USERNAME_TESTING}@'%' identified by $${MYSQL_PASSWORD_TESTING};GRANT ALL PRIVILEGES ON $${MYSQL_DATABASE_TESTING}.* TO $${MYSQL_USER}@'%';" > /docker-entrypoint-initdb.d/init.sql'
