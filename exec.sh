#!/bin/bash

# Wrapper para alterar as permissões dos arquivos criados pelo comando
# Ex: exec.sh composer install

timeIni=`date --iso-8601='ns'`

eval "$@"

find ./ -path ./_docker -prune -o -newerct "$timeIni" -exec chmod g+rwX {} \;