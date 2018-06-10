#!/bin/sh
set -e

echo $APP_ENV >> deploy.txt
echo "var1: $APP_ENV" >> deploy.txt
echo "var2: $WEBSITES_ENABLE_APP_SERVICE_STORAGE" >> deploy.txt

echo "Starting SSH ..."
service ssh start

## first arg is `-f` or `--some-option`
#if [ "${1#-}" != "$1" ]; then
#	set -- apache2-foreground "$@"
#fi

if [ "$1" = 'apache2-foreground' ] || [ "$1" = 'bin/console' ]; then
	if [ "$APP_APP_ENV" != 'prod' ]; then
		composer install --prefer-dist --no-progress --no-suggest --no-interaction  >> deploy.txt
#		bin/console assets:install
#		bin/console doctrine:schema:update -f
	fi

	# Permissions hack because setfacl does not work on Mac and Windows
	chown -R www-data var
fi

env | while read var ; do
  if (echo $var|grep -E "^APP_">/dev/null); then
    # remove PHP_INI_ENV_ prefix
    var=`echo $var | cut -f 2- -d "_"`
    echo "export $var" >> /etc/environment
  fi
done

echo ". /etc/environment" >> /etc/apache2/envvars

cat /etc/apache2/envvars

exec docker-php-entrypoint "$@"
