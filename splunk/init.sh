#!/bin/bash

# Usa o entrypoint padrão do container Splunk para inicializar
echo "Iniciando Splunk com configurações padrão..."

# Inicia o Splunk usando o método padrão do container oficial
/sbin/entrypoint.sh start-service &

# Aguarda o Splunk estar pronto
echo "Aguardando Splunk estar pronto..."
timeout=50
counter=0
while [ $counter -lt $timeout ]; do
    if curl -s "http://localhost:8000" > /dev/null 2>&1; then
        echo "Splunk está pronto!"
        break
    fi
    echo "Aguardando Splunk estar pronto... ($counter/$timeout)"
    sleep 10
    counter=$((counter + 10))
done

if [ $counter -ge $timeout ]; then
    echo "Timeout aguardando Splunk iniciar"
    exit 1
fi

# Aguarda um pouco mais para garantir que a API esteja disponível
sleep 30

echo "Configurando HEC..."

# Cria o índice primeiro
/opt/splunk/bin/splunk add index rails_app -auth admin:SenhaForte123 2>/dev/null || echo "Índice rails_app já existe"

# Cria o HEC token para o Rails app
/opt/splunk/bin/splunk http-event-collector create \
  -name "rails_app" \
  -index rails_app \
  -description "Token para aplicação Rails" \
  -source "middleware" \
  -sourcetype "_json" \
  -token "32bb54a7-646a-4d3e-bf65-3cbbd9075a56" \
  -uri http://localhost:8089 \
  -auth admin:SenhaForte123 2>/dev/null || echo "HEC token já existe"

# Habilita o HEC
/opt/splunk/bin/splunk http-event-collector enable -uri http://localhost:8089 -auth admin:SenhaForte123

echo "HEC configurado com sucesso!"

# Mantém o container rodando
wait
