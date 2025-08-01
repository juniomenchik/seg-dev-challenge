# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

# Classe helper para logging estruturado com envio para Splunk
class AppLogger
  def self.splunk_enabled?
    ENV['SPLUNK_TOKEN'].present? && ENV['SPLUNK_TOKEN'] != 'your-hec-token'
  end

  def self.send_to_splunk(log_data)
    return unless splunk_enabled?

    begin
      splunk_host = ENV.fetch('SPLUNK_HOST', 'splunk')
      splunk_port = ENV.fetch('SPLUNK_PORT', '8088')
      splunk_token = ENV.fetch('SPLUNK_TOKEN', '32bb54a7-646a-4d3e-bf65-3cbbd9075a56')

      uri = URI("https://#{splunk_host}:#{splunk_port}/services/collector/event")  # Manter https como no curl

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true  # Mudança para true para usar HTTPS como no curl
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE  # Pular verificação SSL para localhost
      http.read_timeout = 10
      http.open_timeout = 10

      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Splunk #{splunk_token}"
      request['Content-Type'] = 'application/json'

      # Estrutura igual ao curl que funciona
      splunk_payload = {
        event: log_data,  # Enviar o objeto completo como no formato que funciona
        index: "main"
      }
      request.body = splunk_payload.to_json

      response = http.request(request)

      unless response.code.to_i == 200
        Rails.logger.warn "Falha ao enviar para Splunk: #{response.code} - #{response.body}"
      else
        Rails.logger.debug "Log enviado com sucesso para Splunk HEC"
      end
    rescue => e
      Rails.logger.warn "Erro ao enviar para Splunk: #{e.message}"
    end
  end

  def self.info(message, data = {})
    log_data = {
      level: "INFO",
      message: message,
      timestamp: Time.current.utc.iso8601,
      application: "seg-dev-challenge",
      environment: Rails.env
    }.merge(data)

    Rails.logger.info(log_data.to_json)
    send_to_splunk(log_data)
  end

  def self.error(message, data = {})
    log_data = {
      level: "ERROR",
      message: message,
      timestamp: Time.current.utc.iso8601,
      application: "seg-dev-challenge",
      environment: Rails.env
    }.merge(data)

    Rails.logger.error(log_data.to_json)
    send_to_splunk(log_data)
  end

  def self.warn(message, data = {})
    log_data = {
      level: "WARN",
      message: message,
      timestamp: Time.current.utc.iso8601,
      application: "seg-dev-challenge",
      environment: Rails.env
    }.merge(data)

    Rails.logger.warn(log_data.to_json)
    send_to_splunk(log_data)
  end

  def self.debug(message, data = {})
    log_data = {
      level: "DEBUG",
      message: message,
      timestamp: Time.current.utc.iso8601,
      application: "seg-dev-challenge",
      environment: Rails.env
    }.merge(data)

    Rails.logger.debug(log_data.to_json)
    send_to_splunk(log_data)
  end
end
