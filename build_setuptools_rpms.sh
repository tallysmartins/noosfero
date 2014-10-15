#!/bin/bash

# Atualizando os repositorios
mr checkout

# Copiando os arquivos de configuração editados
CONFIGS="bottle mailman-api"

for cfg in $CONFIGS; do
    echo "Copying $cfg setup.cfg...";
    cp cfg/${cfg}_setup.cfg $cfg/setup.cfg
done

# Criando os rpms
DIRS="six simplejson paste bottle mailman-api"

mkdir -p packages

for dir in $DIRS; do
    cd $dir;
    python setup.py bdist_rpm;
    cp dist/*.rpm ../packages;
    cd ..;
done

