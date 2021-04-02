FactoryBot.define do
   factory :invoice do
      status { ["packaged", "returned", "shipped"] }
      customer
      merchant
   end
 end
