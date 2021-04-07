class Api::V1::SearchesController < ApplicationController

  def find_one_merchant
    render json: MerchantSerializer.new(Merchant.find_one(params[:name]))
    # MerchantFindOneSerializer.new(Merchant.find_one(params[:name]))
  end

  def find_all_items
    render json: ItemSerializer.new(Item.search(params[:name]))
  end
end
