class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_type :merchant_revenue
  attribute :revenue do |object|
    object.total_revenue
  end
end
