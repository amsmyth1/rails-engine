class Api::V1::MerchantsController < ApplicationController

  def index
    if params[:page] == "0"
      render json: MerchantSerializer.new(Merchant.all.paginate(page: 1, per_page: params[:per_page]))
    else
      render json: MerchantSerializer.new(Merchant.all.paginate(page: params[:page], per_page: params[:per_page]))
    end
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def revenue
    render json: RevenueSerializer.new(Merchant.total_revenue(params[:merchant_id]))
  end
end
