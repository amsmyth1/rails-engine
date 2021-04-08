class Api::V1::SearchesController < ApplicationController

  def find_one_merchant
    merchant = Merchant.find_one(params[:name])
    if merchant.class == Array
      render json: {error: "error", data: {}}, status: :bad_request
    else
      render json: MerchantSerializer.new(merchant)
    end
  end


  def find_all_items
    render json: ItemSerializer.new(Item.search(params[:name]))
  end

  def find_one_item_by_price
    if params[:name] != nil && (params[:max_price] != nil || params[:min_price] != nil)
      render json: {error: "error"}, status: :bad_request
    elsif params[:max_price] != nil && params[:min_price] != nil
      item = Item.search_one_price_range(params[:min_price].to_i, params[:max_price].to_i)
      if item.nil?
        render json: {error: "error"}
      else
        render json: ItemSerializer.new(item)
      end
    elsif params[:min_price] != nil
      item = Item.search_one_min_price(params[:min_price].to_i)
      if item.class == Item
        render json: ItemSerializer.new(item)
      else
        render json: {data: {}}
      end
    else params[:max_price] != nil
      render json: ItemSerializer.new(Item.search_one_max_price(params[:max_price].to_i))
    end
  end
end
