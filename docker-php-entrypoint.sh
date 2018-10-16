#!/bin/sh
set -e

if [ "${1#-}" != "$1" ]; then
	set -- /usr/bin/supervisord "$@"
fi

# Atualizar dependências se for um projeto Laravel
if [ -f "artisan" ]; then
    if ! [ -f ".env" ] && [ -f ".env.example" ]; then
        cp .env.example .env
    fi

    if [ -f "composer.json" ] && ! [ -d "vendor" ]; then
        composer install --no-interaction --prefer-dist

        if [ -f "artisan"]; then
            php artisan migrate
            php artisan db:seed
        fi
    fi
fi

exec "$@"