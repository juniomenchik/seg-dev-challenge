class TbPoliciesController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action only: [:edit, :update] do
    require_scope!("ADMIN_SCOPE")
  end
  # Se quiser proteger o index também, descomente a linha abaixo:
  # before_action only: [:index] do
  #   require_scope!("admin_scope")
  # end

  # Método reutilizável para checagem de escopos
  def require_scope!(*scopes)
    payload = request.env["jwt.payload"]
    user_scopes = payload && payload["scope"].to_s.split
    unless user_scopes && (user_scopes & scopes).any?
      render json: { error: "Acesso restrito para seu conjunto de escopos!" }, status: :forbidden and return
    end
  end

  # Função para checar se o usuário possui pelo menos 1 dos scopes informados
  def has_scope?(scopes)
    payload = request.env["jwt.payload"]
    user_scopes = payload && payload["scope"].to_s.split
    return false unless user_scopes && scopes.is_a?(Array)
    (user_scopes & scopes).any?
  end

  # GET /tb_policies
  def index
    if has_scope?(["ADMIN_SCOPE", "OPERATOR_SCOPE"])
      @tb_policies = TbPolicy.all
      render json: @tb_policies, status: :ok
    else
      payload = request.env["jwt.payload"]
      cpf = payload && payload["sub"]
      if cpf
        policy = TbPolicy.find_by_tb_customer_id(cpf)
        if policy
          render json: policy, status: :ok
        else
          render json: { error: "Policy não encontrada para o CPF informado" }, status: :not_found
        end
      else
        render json: { error: "Token inválido ou sem CPF" }, status: :unauthorized
      end
    end
  end

  # GET /tb_policies/1
  def show

  end

  # POST /tb_policies
  def create

  end

  # PATCH/PUT /tb_policies/1
  def update

  end

  # DELETE /tb_policies/1
  def destroy

  end

  def edit
    @tb_policy = TbPolicy.find(params[:id])
    render json: @tb_policy, status: :ok
  end

  private

  def tb_policy_params
    params.require(:tb_policy).permit(:name, :description, :active)
  end

end
