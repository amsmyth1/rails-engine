FactoryBot.define do
  factory :invoice_item do
    sequence :quantity do |n|
      n + 5
    end
    sequence :unit_price do |n|
      n + 1.5
    end
    invoice
    item
  end
end
