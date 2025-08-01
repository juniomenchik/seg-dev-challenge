FROM splunk/splunk:latest

# Apenas copia o script de configuração
COPY splunk/init.sh /opt/splunk/bin/configure-hec.sh
RUN chmod +x /opt/splunk/bin/configure-hec.sh

# Usa o entrypoint padrão do Splunk
# O script de configuração será executado após o Splunk iniciar
