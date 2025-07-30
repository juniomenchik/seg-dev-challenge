class AppController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:token]

  # POST /app/token
  def token
    # Extrai o header Authorization
    auth_header = request.headers['Authorization']
    if auth_header.blank? || !auth_header.start_with?('Basic ')
      render json: { error: 'Authorization header inválido' }, status: :unauthorized and return
    end

    # Decodifica o Basic Auth
    base64_credentials = auth_header.split(' ', 2).last
    credentials = Base64.decode64(base64_credentials).split(':', 2)
    username = credentials[0]
    password = credentials[1]

    # Busca o usuário no banco
    user = TbCustomers.find_by(username: username)
    if user.nil? || user.password != password
      render json: { error: 'Usuário ou senha inválidos' }, status: :unauthorized and return
    end

    # Recupera a role do utilizador
    role = user.role

    # Define o scope baseado na role
    scope = case role
            when 'Admin' then 'ADMIN_SCOPE'
            when 'Operador' then 'OPERATOR_SCOPE'
            when 'Cliente' then 'CLIENT_SCOPE'
            else 'CLIENT_SCOPE'
            end

    # Gera o JWT
    payload = {
      sub: user.id,
      username: user.username,
      role: role,
      scope: scope,
      # exp: 15.minutes.from_now.to_i
      exp: 1.minutes.from_now.to_i
    }
    secret = Rails.application.secret_key_base
    token = JWT.encode(payload, secret, 'HS256')

    render json: {
      scope: scope,
      token: token
    }
  end
end
