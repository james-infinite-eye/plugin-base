#!/usr/bin/env bash

PLUGIN=${1-none}


# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")

# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

cd "$SCRIPTPATH/../../../.."


TEMP_FILE_PATH='./drop_all_tables.sql'

DBNAME="wordpress"
DBPASS="root"
DBUSER="root"

echo "SET FOREIGN_KEY_CHECKS = 0;" > $TEMP_FILE_PATH
( mysqldump --add-drop-table --no-data -hdb -u$DBUSER -p$DBPASS $DBNAME | grep 'DROP TABLE' ) >> $TEMP_FILE_PATH
echo "SET FOREIGN_KEY_CHECKS = 1;" >> $TEMP_FILE_PATH
mysql --host=db -u$DBUSER -p$DBPASS $DBNAME < $TEMP_FILE_PATH
rm -f $TEMP_FILE_PATH

# Reset WordPress
find ./wp-content -mindepth 1 ! -regex '^./wp-content/plugins\(/.*\)?' -delete
# wp --allow-root core download --force --version=nightly
wp --allow-root core download --force
wp --allow-root core install --url=localdev --title="Dev" --admin_name=admin --admin_password=pass --admin_email=test@test.com
find ./wp-content/plugins -mindepth 1 ! -regex '^./wp-content/plugins/plugin-base\(/.*\)?' -delete

wp --allow-root plugin activate plugin-base/mail-tools.php

# Install Test Suite
bash /var/www/html/wp-content/plugins/plugin-base/bin/install-wp-tests.sh wordpress_tests root root db latest true

chown -R www-data:www-data wp-content

# Login user
wp --allow-root package install aaemnnosttv/wp-cli-login-command
wp --allow-root login install --activate
wp --allow-root login as admin