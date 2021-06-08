#!/usr/bin/env bash
 
composer install -n
npm install
npm run dev
composer dump-env dev
# bin/console doc:mig:mig --no-interaction
# bin/console doc:fix:load --no-interaction
 
exec "$@"