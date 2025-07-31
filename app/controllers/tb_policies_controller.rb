class TbPoliciesController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action only: [:edit, :update] do
    require_scope!("ADMIN_SCOPE")
  end

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
      # render json: @tb_policies, status: :ok
    end
    jwt = request.env["jwt.payload"]
    @tb_policies = TbPolicy.find_by(tb_customer_id: jwt["sub"])

    render json: @tb_policies, status: :ok
  end

  def show
    unless has_scope?(["ADMIN_SCOPE", "OPERATOR_SCOPE"])
      render json: { error: "Acesso restrito para seu conjunto de escopos!" }, status: :forbidden and return
    end

    @tb_policy = TbPolicy.find_by(id: params[:id])
    if @tb_policy
      render json: @tb_policy, status: :ok
    else
      render json: { error: "Política não encontrada" }, status: :not_found
    end
  end

  # POST /tb_policies
  def create

    unless has_scope?(["ADMIN_SCOPE", "OPERATOR_SCOPE"])
      render json: { error: "Acesso restrito para seu conjunto de escopos!" }, status: :forbidden and return
    end

    service = TbPolicyCreatorService.new(tb_policy_params, request.env["jwt.payload"])

    result = service.saveEntity

    if result[:success]
      render json: result[:tb_policy], status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tb_policies/1
  def update

    service = TbPolicyCreatorService.new(tb_policy_params, request.env["jwt.payload"])

    result = service.updateEntity(params[:id])

    if result[:success]
      render json: result[:tb_policy], status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end

  end

  # DELETE /tb_policies/1
  def destroy

  end

  def edit

  end

  private

  def tb_policy_params
    params.require(:tb_policy).permit(:id, :policy_number, :tb_customer_id, :start_date, :end_date, :status, :created_at, :updated_at)
  end
end
