class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :unit_price
  belongs_to :merchant
end
