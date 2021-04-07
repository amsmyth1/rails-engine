class TopMerchantsRevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_type :merchant_name_revenue
  attribute :name do |object|
    object.name
  end
  attribute :revenue do |object|
    object.rev
  end

end
