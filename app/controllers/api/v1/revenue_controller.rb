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
    total_revenue = Transaction.total_revenue_by_date(clean_date(params[:start]), clean_date(params[:end]))
    render json: DateRevenueSerializer.new(Transaction.new, {params: {rev: total_revenue}})
  end

  private

  def clean_date(date)
    new_date = date.split("-")
    Date.new(new_date[0].to_i, new_date[1].to_i, new_date[2].to_i)
  end
end
