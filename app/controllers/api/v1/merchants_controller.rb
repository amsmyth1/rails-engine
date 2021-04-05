class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all.paginate(page: params[:page], per_page: params[:per_page]))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end
