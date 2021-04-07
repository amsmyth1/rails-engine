class DateRevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_type :revenue
  attribute :revenue do |object, params|
    params[:rev][0]
  end
end
