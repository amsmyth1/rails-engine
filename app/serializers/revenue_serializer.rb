class RevenueSerializer
  include FastJsonapi::ObjectSerializer
    # attributes :name
    set_type :merchant_revenue
    attribute :revenue do |object|
      object.total_revenue
    end
  # attribute :id
  # attribute :revenue do
  #   binding.pry
  #   Merchant.total_revenue(params[:merchant_id])
  # end
end
