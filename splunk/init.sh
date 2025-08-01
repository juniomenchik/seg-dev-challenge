#!/bin/bash

# Inicia o Splunk usando o entrypoint padrão
/sbin/entrypoint.sh start &

# Aguarda o Splunk estar pronto - verifica se o serviço management está ativo
while ! curl -k -u admin:SenhaForte123 https://localhost:8089/services/server/info > /dev/null 2>&1; do
  echo "Aguardando Splunk estar pronto..."
  sleep 10
done

echo "Splunk iniciado com sucesso, configurando HEC..."

# Cria o HEC token para o Rails app
/opt/splunk/bin/splunk http-event-collector create rails_hec \
  -name "Rails App HEC" \
  -uri https://localhost:8089 \
  -token 32bb54a7-646a-4d3e-bf65-3cbbd9075a56 \
  -index main \
  -auth admin:SenhaForte123

# Habilita o HEC
/opt/splunk/bin/splunk http-event-collector enable -uri https://localhost:8089 -auth admin:SenhaForte123

echo "HEC configurado com sucesso!"

# Mantém o container rodando
wait
