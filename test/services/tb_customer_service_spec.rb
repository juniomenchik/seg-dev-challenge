# frozen_string_literal: true

require 'test_helper'

class TbCustomerServiceTest < ActiveSupport::TestCase
  def setup
    # Limpa a tabela antes de cada teste
    TbCustomers.delete_all
  end

  def teardown
    # Cleanup code if needed
  end

  test "cria um novo TbCustomer com sucesso" do
    params = {
      id: "82966043709",
      username: "usuario_exemplo_92761341589",
      password: "2?DNti2Y%6bT",
      role: "admin"
    }

    service = TbCustomerService.new(params)
    result = service.create

    assert_equal true, result[:success]
    assert_not_nil result[:tb_customer]
    assert_equal '82966043709', result[:tb_customer].id
    assert_equal 'usuario_exemplo_92761341589', result[:tb_customer].username
    assert_equal 'admin', result[:tb_customer].role
  end

  test "falha ao criar TbCustomer com ID duplicado" do
    # Cria primeiro customer
    params = {
      id: "82966043709",
      username: "usuario_exemplo_92761341589",
      password: "2?DNti2Y%6bT",
      role: "admin"
    }

    service = TbCustomerService.new(params)
    result = service.create

    # Tenta criar segundo customer com mesmo ID
    params = {
      id: "82966043709",
      username: "usuario_exemplo_92761341589",
      password: "2?DNti2Y%6bT",
      role: "admin"
    }
    service2 = TbCustomerService.new(params)
    result2 = service2.create

    assert_equal true, result[:success]
    assert_equal false, result2[:success]
    assert_includes result2[:errors][:id], "CPF has already been taken!!!"
  end

  test "falha ao criar TbCustomer com username duplicado" do
    # Cria primeiro customer
    params = {
      id: "82966043708",
      username: "usuario_exemplo_92761341589",
      password: "2?DNti2Y%6bT",
      role: "admin"
    }
    service = TbCustomerService.new(params)
    result = service.create


    params2 = {
      id: "82966043709",
      username: "usuario_exemplo_92761341589",
      password: "2?DNti2Y%6bT",
      role: "admin"
    }
    service2 = TbCustomerService.new(params2)
    result2 = service2.create

    assert_equal true, result[:success]
    assert_equal false, result2[:success]
    assert_includes result2[:errors][:username], "USERNAME has already been taken!!!"
  end

  test "cria um novo TbCustomer com sucesso, e faz o update dele" do
    params = {
      id: "82966043709",
      username: "usuario_exemplo_92761341589",
      password: "2?DNti2Y%6bT",
      role: "admin"
    }

    service = TbCustomerService.new(params)
    result = service.create

    assert_equal true, result[:success]
    assert_not_nil result[:tb_customer]
    assert_equal '82966043709', result[:tb_customer].id
    assert_equal 'usuario_exemplo_92761341589', result[:tb_customer].username
    assert_equal 'admin', result[:tb_customer].role



    paramsUpdate = {
      id: "82966043709",
      username: "usernameChanged",
      password: "2?DNti2Y%6bT",
      role: "operator"
    }

    serviceUpdate = TbCustomerService.new(paramsUpdate)
    resultUpdt = serviceUpdate.update

    assert_equal true, resultUpdt[:success]
    assert_not_nil resultUpdt[:tb_customer]
    assert_equal '82966043709', resultUpdt[:tb_customer].id
    assert_equal 'usernameChanged', resultUpdt[:tb_customer].username
    assert_equal 'operator', resultUpdt[:tb_customer].role

  end


  test "cria um novo TbCustomer com sucesso, e faz o delete dele" do
    params = {
      id: "82966043709",
      username: "usuario_exemplo_92761341589",
      password: "2?DNti2Y%6bT",
      role: "admin"
    }

    service = TbCustomerService.new(params)
    result = service.create

    assert_equal true, result[:success]
    assert_not_nil result[:tb_customer]
    assert_equal '82966043709', result[:tb_customer].id
    assert_equal 'usuario_exemplo_92761341589', result[:tb_customer].username
    assert_equal 'admin', result[:tb_customer].role


    service = TbCustomerService.new(id: params[:id])

    result = service.deleteById
    assert_equal true, result[:success]

  end


end

