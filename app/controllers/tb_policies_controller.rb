class TbPoliciesController < ApplicationController
  before_action :set_tb_policy, only: %i[ show edit update destroy ]

  # GET /tb_policies
  def index
     # CLIENTE visualiza apenas as suas
    @tb_policies = PoliciesService.all
  end

  # GET /tb_policies/1
  def show
    # @tb_policy já está setado pelo before_action
  end

  # GET /tb_policies/new
  def new
    @tb_policy = TbPolicy.new
  end

  # GET /tb_policies/1/edit
  def edit
    # @tb_policy já está setado pelo before_action
  end

  # POST /tb_policies
  def create
    @tb_policy = PoliciesService.create(tb_policy_params)
    if @tb_policy.persisted?
      redirect_to @tb_policy, notice: 'Policy criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tb_policies/1
  def update
    if PoliciesService.update(@tb_policy, tb_policy_params)
      redirect_to @tb_policy, notice: 'Policy atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tb_policies/1
  def destroy
    PoliciesService.destroy(@tb_policy)
    redirect_to tb_policies_url, notice: 'Policy removida com sucesso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tb_policy
      @tb_policy = PoliciesService.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tb_policy_params
      params.require(:tb_policy).permit(:nome, :descricao, :valor)
    end
end
