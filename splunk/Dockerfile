FROM splunk/splunk:latest

USER root

COPY splunk/init.sh /opt/splunk/bin/init.sh
RUN chmod +x /opt/splunk/bin/init.sh

USER splunk

CMD ["/opt/splunk/bin/init.sh"]
