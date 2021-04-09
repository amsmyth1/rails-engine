class Api::V1::RevenueController < ApplicationController
  include DateCheckable

  def merchant_revenue
    if Merchant.where(id: params[:merchant_id]).count > 0
      render json: RevenueSerializer.new(Merchant.find(params[:merchant_id]))
    else
      render json: {error: "the merchant id is not valid"}, status: 404
    end
  end

  def top_merchants
    if params[:quantity].nil?
      render json: {error: "please enter a quantity"}, status: 400
    elsif params[:quantity].empty? || params[:quantity].to_i == 0
      render json: {error: "please enter a quantity"}, status: 400
    else
      render json: TopMerchantsRevenueSerializer.new(Merchant.top_merchants_by_total_revenue(params[:quantity]))
    end
  end

  def unshipped
    if params[:quantity].nil?
      render json: UnshippedRevenueSerializer.new(Invoice.potential_revenue(10))
    elsif params[:quantity] == "" || params[:quantity].to_i == 0
      render json: {error: "please enter a quantity"}, status: 400
    else
      render json: UnshippedRevenueSerializer.new(Invoice.potential_revenue(params[:quantity].to_i))
    end
  end

  def revenue_by_date
    if DateCheckable.revenue_by_date_error?(params[:start], params[:end])
      render json: {error: "please enter correct start and end date"}, status: 400
    else
      total_revenue = Transaction.total_revenue_by_date(DateCheckable.clean_date(params[:start]), DateCheckable.clean_date(params[:end]))
      render json: DateRevenueSerializer.new(Transaction.new, {params: {rev: total_revenue}})
    end
  end
end
