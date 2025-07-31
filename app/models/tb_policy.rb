class TbPolicy < ApplicationRecord
  belongs_to :tb_customer, class_name: "TbCustomers", foreign_key: "tb_customer_id"
end
