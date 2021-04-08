class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    if Merchant.where(id: params[:merchant_id]).count > 0
      @merchant = Merchant.find(params[:merchant_id])
      if params[:per_page] == nil
        params[:per_page] = 100
      end
      render json: ItemSerializer.new(@merchant.items.paginate(page: params[:page], per_page: params[:per_page]))
    else
      render json: {error: "merchant does not exist with that id"}, status: 404
    end
  end
end
