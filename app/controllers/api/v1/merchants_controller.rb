class Api::V1::MerchantsController < ApplicationController

  def index
    binding.pry

    render json: MerchantSerializer.new(Merchant.all.offset(page * 20).limit(20))
  end

  def show
    render json: Merchant.find(params[:id])
  end

  private

  def page
    params[:page] || 0
  end
end
