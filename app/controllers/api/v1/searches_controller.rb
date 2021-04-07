class Api::V1::SearchesController < ApplicationController

  def find_one_merchant
    MerchantFindOneSerializer.new(Merchant.find_one(params[:name]))
  end

  def find_all_items
    binding.pry
    ItemsFindAllSerializer.new(Item.search(params[:name]))
  end
end
