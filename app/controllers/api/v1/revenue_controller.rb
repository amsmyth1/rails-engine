class Api::V1::RevenueController < ApplicationController

  def merchant_revenue
    render json: RevenueSerializer.new(Merchant.find(params[:merchant_id]))
  end

  def top_merchants
    binding.pry
  end
end
