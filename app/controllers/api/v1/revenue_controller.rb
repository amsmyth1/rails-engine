class Api::V1::RevenueController < ApplicationController

  def merchant_revenue
    render json: RevenueSerializer.new(Merchant.find(params[:merchant_id]))
  end

  def top_merchants
    render json: TopMerchantsRevenueSerializer.new(Merchant.top_merchants_by_total_revenue(params[:quantity]))
  end

  def unshipped
    render json: UnshippedRevenueSerializer.new(Merchant.total_revenue_of_unshipped_items)
  end

  def revenue_by_date
    binding.pry
    render json: RevenueSerializer.new(Transaction.total_revenue_by_date(start_date, end_date))
  end
end
