#!/bin/sh
set -e
cd $HOME
if [ ! -n "$WERCKER_S3DEL_KEY_ID" ]
then
    fail 'missing or empty option key_id, please check wercker.yml'
fi

if [ ! -n "$WERCKER_S3DEL_KEY_SECRET" ]
then
    fail 'missing or empty option key_secret, please check wercker.yml'
fi

if [ ! -n "$WERCKER_S3DEL_URL" ]
then
    fail 'missing or empty option url, please check wercker.yml'
fi

if [ ! -n "$WERCKER_S3DEL_RECURSIVE" ]
then
    RECURSIVE=""
else
    RECURSIVE="--recursive"
fi

if ! type s3cmd &> /dev/null ;
then
    info 's3cmd not found, start installing it'
    wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
    sudo wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
    sudo apt-get update && sudo apt-get install s3cmd
    success 's3cmd installed succesfully'
else
    info 'skip s3cmd install, command already available'
    debug "type s3cmd: $(type s3cmd)"
fi

if [ -e '.s3cfg' ]
then
    warn '.s3cfg file already exists in home directory and will be overwritten'
fi

echo '[default]' > '.s3cfg'
echo "access_key=$WERCKER_S3DEL_KEY_ID" >> .s3cfg
echo "secret_key=$WERCKER_S3DEL_KEY_SECRET" >> .s3cfg
debug "generated .s3cfg for key $WERCKER_S3DEL_KEY_ID"

info 'starting s3 delete'

# TODO make public an option

cd "$WERCKER_ROOT"

set +e
debug "s3cmd del --verbose $RECURSIVE '$WERCKER_S3DEL_URL'"
success 'finished s3 delete';
set -e
