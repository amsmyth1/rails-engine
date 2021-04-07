class UnshippedRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attribute :potential_revenue do |object|
    object.rev
  end

end
