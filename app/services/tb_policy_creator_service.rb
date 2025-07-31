# app/services/tb_policy_creator_service.rb
class TbPolicyCreatorService
  def initialize(params, payload)
    @params = params
    @payload = payload
  end

  def updateEntity(id)
    tbcustomer = TbCustomers.find_by(id: @payload["sub"])

    tb_policy = TbPolicy.find_by(id: id)
    unless tb_policy
      return { success: false, errors: ["TbPolicy não encontrado para o ID informado."] }
    end

    unless tbcustomer
      return { success: false, errors: ["Cliente não encontrado para o ID informado."] }
    end

    if @params[:policy_number] && @params[:policy_number].to_s.length != 12
      return { success: false, errors: ["O policy_number deve ter exatamente 12 dígitos."] }
    end


    tb_policy.policy_number = @params["policy_number"]
    tb_policy.tb_customer_id = @params["tb_customer_id"]
    tb_policy.start_date = @params[:start_date]
    tb_policy.end_date = @params[:end_date]
    tb_policy.status = @params[:status]
    tb_policy.updated_at = Time.now

    if tb_policy.save
      { success: true, tb_policy: tb_policy }
    else
      { success: false, errors: tb_policy.errors.full_messages }
    end
  end

  def saveEntity
    puts "ID recebido do payload: ", @payload["sub"]
    tbcustomer = TbCustomers.find_by(id: @payload["sub"])
    puts "Resultado da busca do cliente: ", tbcustomer.inspect

    unless tbcustomer
      return { success: false, errors: ["Cliente não encontrado para o ID informado."] }
    end

    tb_policy = TbPolicy.new(@params)

    tb_policy.id = SecureRandom.uuid
    tb_policy.policy_number = SecureRandom.random_number(10**12).to_s.rjust(12, '0')
    tb_policy.tb_customer_id = @payload["sub"]
    tb_policy.start_date = @params[:start_date]
    tb_policy.end_date = @params[:end_date]
    tb_policy.status = @params[:status]
    tb_policy.created_at = Time.now
    tb_policy.updated_at = Time.now

    res = tb_policy.save
    unless res
      puts "Erros ao salvar TbPolicy: #{tb_policy.errors.full_messages.inspect}"
    end

    if res
      puts "INSERT realizado na base para TbPolicy: #{tb_policy.inspect}"
      { success: true, tb_policy: tb_policy }
    else
      { success: false, errors: tb_policy.errors.full_messages }
    end
  end
end