require 'rails_helper'

RSpec.describe api do

  get 'api/v1/items'
  response
  JSON.parse(response.body, symbolize_name:true)

  expect(response.status).to eq(200)
end 
