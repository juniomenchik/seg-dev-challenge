class TbCustomerService
  def initialize(params)
    @params = params
  end

  def create
    tb_customer = TbCustomers.new(@params)
    tb_customer.created_at = Time.now
    tb_customer.updated_at = Time.now

    if TbCustomers.exists?(id: tb_customer.id)
      return { success: false, errors: { id: ["CPF has already been taken!!!"] } }
      end

    if TbCustomers.exists?(username: tb_customer.username)
      return { success: false, errors: { username: ["USERNAME has already been taken!!!"] } }
    end

    if tb_customer.save
      { success: true, tb_customer: tb_customer }
    else
      { success: false, errors: tb_customer.errors }
    end
  end

  def update
    tb_customer = TbCustomers.find_by(id: @params[:id])
    return { success: false, errors: { id: ["Customer not found"] } } unless tb_customer

    tb_customer.assign_attributes(@params)
    tb_customer.updated_at = Time.now

    if tb_customer.save
      { success: true, tb_customer: tb_customer }
    else
      { success: false, errors: tb_customer.errors }
    end
  end


  def deleteById
    tb_customer = TbCustomers.find_by(id: @params[:id])
    return { success: false, errors: { id: ["Customer not found"] } } unless tb_customer

    if tb_customer.destroy
      { success: true }
    else
      { success: false, errors: tb_customer.errors }
    end
  end

end

