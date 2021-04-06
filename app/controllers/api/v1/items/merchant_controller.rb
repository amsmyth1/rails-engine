class Api::V1::Items::MerchantController < ApplicationController

  def index
    merchant_id = (Item.find(params[:item_id])).merchant.id
    render json: MerchantSerializer.new(Merchant.find(merchant_id))
  end

end
