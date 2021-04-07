class Api::V1::SearchesController < ApplicationController

  def find_one_merchant
    render json: MerchantSerializer.new(Merchant.find_one(params[:name]))
    # MerchantFindOneSerializer.new(Merchant.find_one(params[:name]))
  end

  def find_all_items
    render json: ItemSerializer.new(Item.search(params[:name]))
  end

  def find_one_item_by_price
    if params[:max_price] != nil && params[:min_price] != nil
      item = Item.search_one_price_range(params[:min_price].to_i, params[:max_price].to_i)
      if item.nil?
        render json: ItemSerializer.new{Item.new}
      else
        render json: ItemSerializer.new(item)
      end
    elsif params[:min_price] != nil
      render json: ItemSerializer.new(Item.search_one_min_price(params[:min_price].to_i))
    else params[:max_price] != nil
      render json: ItemSerializer.new(Item.search_one_max_price(params[:max_price].to_i))
    end
  end
end
