class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all.limit(20))
  end

  def show
    render json: Merchant.find(params[:id])
  end
end
