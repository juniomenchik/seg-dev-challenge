# frozen_string_literal: true

require 'test_helper'

class TbPolicyCreatorServiceTest < ActiveSupport::TestCase
  def setup
    # Limpa as tabelas antes de cada teste
    TbPolicy.delete_all
    TbCustomers.delete_all

    # Cria um customer para usar nos testes
    @customer = TbCustomers.create!(
      id: "82966043709",
      username: "usuario_teste",
      password: "senha123",
      role: "admin"
    )

    @payload = {
      "sub" => @customer.id,
      "scope" => "ADMIN_SCOPE"
    }
  end

  def teardown
    # Cleanup code if needed
  end

  test "cria uma nova policy com sucesso" do
    params = {
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    }

    service = TbPolicyCreatorService.new(params, @payload)
    result = service.saveEntity

    assert_equal true, result[:success]
    assert_not_nil result[:tb_policy]
    assert_equal @customer.id, result[:tb_policy].tb_customer_id
    assert_equal "active", result[:tb_policy].status
    assert_equal 12, result[:tb_policy].policy_number.length
  end

  test "falha ao criar policy com customer inexistente" do
    payload_invalid = {
      "sub" => "99999999999",
      "scope" => "ADMIN_SCOPE"
    }

    params = {
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    }

    service = TbPolicyCreatorService.new(params, payload_invalid)
    result = service.saveEntity

    assert_equal false, result[:success]
    assert_includes result[:errors], "Cliente não encontrado para o ID informado."
  end

  test "encontra policy por ID com sucesso" do
    # Cria uma policy primeiro
    policy = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: @customer.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    )

    service = TbPolicyCreatorService.new({}, @payload)
    result = service.findById(policy.id)

    assert_equal true, result[:success]
    assert_not_nil result[:tb_policy]
    assert_equal policy.id, result[:tb_policy].id
  end

  test "falha ao encontrar policy inexistente" do
    service = TbPolicyCreatorService.new({}, @payload)
    result = service.findById("policy_inexistente")

    assert_equal false, result[:success]
    assert_includes result[:errors], "Police não encontrado para o ID informado."
  end

  test "atualiza policy com sucesso" do
    # Cria uma policy primeiro
    policy = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: @customer.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    )

    params = {
      "policy_number" => "123456789012",
      "tb_customer_id" => @customer.id,
      start_date: Date.current + 1.day,
      end_date: Date.current + 2.years,
      status: "inactive"
    }

    service = TbPolicyCreatorService.new(params, @payload)
    result = service.updateEntity(policy.id)

    assert_equal true, result[:success]
    assert_not_nil result[:tb_policy]
    assert_equal "123456789012", result[:tb_policy].policy_number
    assert_equal "inactive", result[:tb_policy].status
  end

  test "falha ao atualizar policy inexistente" do
    params = {
      "policy_number" => "123456789012",
      status: "inactive"
    }

    service = TbPolicyCreatorService.new(params, @payload)
    result = service.updateEntity("policy_inexistente")

    assert_equal false, result[:success]
    assert_includes result[:errors], "TbPolicy não encontrado para o ID informado."
  end

  test "falha ao atualizar policy com policy_number inválido" do
    # Cria uma policy primeiro
    policy = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: @customer.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    )

    params = {
      "policy_number" => "123", # Menos de 12 dígitos
      status: "inactive"
    }

    service = TbPolicyCreatorService.new(params, @payload)
    result = service.updateEntity(policy.id)

    assert_equal false, result[:success]
    assert_includes result[:errors], "O policy_number deve ter exatamente 12 dígitos."
  end

  test "deleta policy com sucesso como admin" do
    # Cria uma policy primeiro
    policy = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: @customer.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    )

    service = TbPolicyCreatorService.new({}, @payload)
    result = service.deleteById(policy.id)

    assert_equal true, result[:success]
    assert_equal "Policy deletado com sucesso.", result[:message]
  end

  test "falha ao deletar policy sem permissão de admin" do
    # Payload sem permissão de admin
    payload_operator = {
      "sub" => @customer.id,
      "scope" => "OPERATOR_SCOPE"
    }

    # Cria uma policy primeiro
    policy = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: @customer.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    )

    service = TbPolicyCreatorService.new({}, payload_operator)
    result = service.deleteById(policy.id)

    assert_equal false, result[:success]
    assert_includes result[:errors], "Apenas administradores podem deletar policies."
  end

  test "falha ao deletar policy inexistente" do
    service = TbPolicyCreatorService.new({}, @payload)
    result = service.deleteById("policy_inexistente")

    assert_equal false, result[:success]
    assert_includes result[:errors], "Policy não encontrado para o ID informado."
  end

  test "lista todas as policies" do
    # Cria algumas policies
    policy1 = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: @customer.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    )

    policy2 = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: @customer.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "inactive"
    )

    service = TbPolicyCreatorService.new({}, @payload)
    result = service.findAll

    assert_equal true, result[:success]
    assert_not_nil result[:tb_policies]
    assert_equal 2, result[:tb_policies].count
  end

  test "lista policies por customer ID" do
    # Cria um segundo customer
    customer2 = TbCustomers.create!(
      id: "98765432100",
      username: "usuario_teste2",
      password: "senha456",
      role: "user"
    )

    # Cria policies para ambos os customers
    policy1 = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: @customer.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    )

    policy2 = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: customer2.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    )

    service = TbPolicyCreatorService.new({}, @payload)
    result = service.findAllById(@customer.id)

    assert_equal true, result[:success]
    assert_not_nil result[:tb_policies]
    assert_equal 1, result[:tb_policies].count
    assert_equal @customer.id, result[:tb_policies].first.tb_customer_id
  end

  test "verifica acesso negado para usuário sem permissão" do
    # Cria um customer diferente
    other_customer = TbCustomers.create!(
      id: "98765432100",
      username: "outro_usuario",
      password: "senha456",
      role: "user"
    )

    # Cria uma policy para o customer original
    policy = TbPolicy.create!(
      id: SecureRandom.uuid,
      policy_number: SecureRandom.random_number(10**12).to_s.rjust(12, '0'),
      tb_customer_id: @customer.id,
      start_date: Date.current,
      end_date: Date.current + 1.year,
      status: "active"
    )

    # Payload do outro customer sem permissões administrativas
    other_payload = {
      "sub" => other_customer.id,
      "scope" => "USER_SCOPE"
    }

    service = TbPolicyCreatorService.new({}, other_payload)
    result = service.findById(policy.id)

    assert_equal false, result[:success]
    assert_includes result[:errors], "Acesso negado."
  end
end
