class PoliciesService

  def self.all
    TbPolicy.all
  end

  def self.find(id)
    TbPolicy.find(id)
  end

  def self.create(params)
    TbPolicy.create(params)
  end

  def self.update(policy, params)
    policy.update(params)
  end

  def self.destroy(policy)
    policy.destroy
  end
end

