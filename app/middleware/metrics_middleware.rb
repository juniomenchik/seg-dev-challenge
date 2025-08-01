# frozen_string_literal: true

class MetricsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Time.current
    request = ActionDispatch::Request.new(env)

    # Log do início da requisição
    AppLogger.info("Requisição iniciada", {
      method: request.method,
      path: request.path,
      user_agent: request.user_agent,
      request_id: request.uuid,
      timestamp: start_time.iso8601
    })

    status, headers, response = @app.call(env)

    end_time = Time.current
    duration = ((end_time - start_time) * 1000).round(2) # em millisegundos

    # Log da resposta com métricas
    AppLogger.info("Requisição concluída", {
      method: request.method,
      path: request.path,
      status: status,
      duration_ms: duration,
      request_id: request.uuid,
      timestamp: end_time.iso8601
    })

    # Log específico para erros
    if status >= 400
      AppLogger.error("Erro na requisição", {
        method: request.method,
        path: request.path,
        status: status,
        duration_ms: duration,
        request_id: request.uuid,
        error_type: status >= 500 ? "server_error" : "client_error"
      })
    end

    [status, headers, response]
  rescue StandardError => e
    end_time = Time.current
    duration = ((end_time - start_time) * 1000).round(2)

    # Log de exceções não capturadas
    AppLogger.error("Exceção não capturada", {
      method: request.method,
      path: request.path,
      exception_class: e.class.name,
      exception_message: e.message,
      duration_ms: duration,
      request_id: request.uuid,
      backtrace: e.backtrace&.first(10)
    })

    raise e
  end
end
