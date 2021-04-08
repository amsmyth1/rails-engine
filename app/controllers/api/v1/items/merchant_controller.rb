class Api::V1::Items::MerchantController < ApplicationController

  def index
    if Item.where(id: params[:item_id]).count > 0
      merchant_id = (Item.find(params[:item_id])).merchant.id
      render json: MerchantSerializer.new(Merchant.find(merchant_id))
    else
      render json: {errors: "item does not exist with that id"}, status: 404
    end
  end
end
