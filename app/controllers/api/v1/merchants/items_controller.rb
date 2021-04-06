class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    if params[:per_page] == nil
      params[:per_page] = 100
    end
    render json: ItemSerializer.new(@merchant.items.paginate(page: params[:page], per_page: params[:per_page]))
  end
end
