class Api::V1::MerchantsController < ApplicationController

  def index
    if params[:page] == "0"
      render json: MerchantSerializer.new(Merchant.all.paginate(page: 1, per_page: params[:per_page]))
    else
      render json: MerchantSerializer.new(Merchant.all.paginate(page: params[:page], per_page: params[:per_page]))
    end
  end

  def show
    if Merchant.where(id: params[:id]).count > 0
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render json: {error: "merchant does not exists with that id"}, status: 404
    end
  end
end
