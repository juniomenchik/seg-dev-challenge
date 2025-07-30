class TbCustomersController < ApplicationController

  before_action :require_admin_scope
  skip_before_action :verify_authenticity_token

  def require_admin_scope
    payload = request.env["jwt.payload"]
    unless payload && payload["scope"] == "ADMIN_SCOPE"
      render json: { error: "Acesso restrito para o Scope Admin" }, status: :forbidden
    end
  end

  # GET /tb_customers
  def index
    @tb_customers = TbCustomers.all
    render json: @tb_customers
  end

  # GET /tb_customers/1
  def show
    @tb_customers = TbCustomers.find_by(id: params[:id])
    render json: @tb_customers
  end

  # POST /tb_customers
  def create
    service = TbCustomerService.new(tb_customer_params.merge(id: params[:id]))

    result = service.create
    if result[:success]
      render json: result[:tb_customer], status: :created
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tb_customers/1
  def update
    service = TbCustomerService.new(tb_customer_params.merge(id: params[:id]))

    result = service.update
    if result[:success]
      render json: result[:tb_customer], status: :ok
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end

  # DELETE /tb_customers/1
  def destroy
    service = TbCustomerService.new(id: params[:id])

    result = service.deleteById
    if result[:success]
      head :no_content
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tb_customer
      @tb_customer = TbCustomers.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tb_customer_params
      params.require(:tb_customer).permit(:username, :password, :role)
    end
end
