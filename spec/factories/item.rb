FactoryBot.define do
   factory :item do
      name { Faker::Food.dish }
      description { Faker::Food.description }
      sequence :unit_price do |n|
        (n + 1.5)
      end
      merchant
   end
 end
