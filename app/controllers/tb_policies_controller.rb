class TbPoliciesController < ApplicationController

  def tb_policy_params
    params.require(:tb_policy).permit(:id, :policy_number, :tb_customer_id, :start_date, :end_date, :status, :created_at, :updated_at)
  end

  skip_before_action :verify_authenticity_token

  before_action do
    @token_service = TbTokenService.new(request)
    @user_cpf = request.env["jwt.payload"] && request.env["jwt.payload"]["sub"]
  end

  before_action only: [:update, :destroy] do
    unless @token_service.has_scope?(["ADMIN_SCOPE"])
      render json: { error: "Escopo insuficiente" }, status: :forbidden
      next
    end
  end

  before_action only: [:create] do
    unless @token_service.has_scope?(%w[ADMIN_SCOPE OPERATOR_SCOPE])
      render json: { error: "Escopo insuficiente" }, status: :forbidden
      next
    end
  end

  def index
    service = TbPolicyCreatorService.new({}, request.env["jwt.payload"])

    if @token_service.has_scope?(["ADMIN_SCOPE", "OPERATOR_SCOPE"])
      result = service.findAll
    else
      result = service.findAllById(@user_cpf)
    end

    if result[:success]
      render json: result[:tb_policies], status: :ok
    else
      render json: { errors: result[:errors] }, status: :not_found
    end
  end

# GET /tb_policies/1
  def show
    service = TbPolicyCreatorService.new({}, request.env["jwt.payload"])

    result = service.findById(params[:id])

    if result[:success]
      render json: result[:tb_policy], status: :ok
    else
      render json: { errors: result[:errors] }, status: :not_found
    end
  end

  # POST /tb_policies
  def create
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
    service = TbPolicyCreatorService.new({}, request.env["jwt.payload"])

    result = service.deleteById(params[:id])

    if result[:success]
      render json: { message: result[:message] }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

end
