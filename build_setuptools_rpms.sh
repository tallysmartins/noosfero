#!/bin/bash

# Atualizando os repositorios
mr checkout

# Copiando os arquivos de configuração editados
CONFIGS="mailman-api"

for cfg in $CONFIGS; do
    echo "Copying $cfg setup.cfg...";
    cp cfg/${cfg}_setup.cfg $cfg/setup.cfg
done

# Criando os rpms na pasta packages
DIRS="mailman-api/paste/six mailman-api/paste mailman-api/bottle 
	mailman-api/simplejson mailman-api"

mkdir -p packages

for dir in $DIRS; do
    curdir=`pwd`
    cd $dir;
    python setup.py bdist_rpm;
    cp dist/*.rpm $curdir/packages;
    cd $curdir;
done

