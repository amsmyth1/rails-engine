class Api::V1::SearchesController < ApplicationController

  def find_one_merchant
    if params[:name].nil? || params[:name] == ""
      render json: {error: "error", data: {}}, status: 400
    else
      merchant = Merchant.find_one(params[:name])
      if merchant.class == Array
        render json: {error: "error", data: {}}, status: :bad_request
      else
        render json: MerchantSerializer.new(merchant)
      end
    end
  end

  def find_all_merchants_by_name
    if params[:name].nil? || params[:name] == ""
      render json: {error: "error", data: []}, status: 400
    else
      merchants = Merchant.find_by_name(params[:name])
      if merchants.empty?
        render json: {error: "error", data: []}, status: 400
      else
        merchants = render json: MerchantSerializer.new(Merchant.find_by_name(params[:name]))
      end
    end
  end

  def find_all_items
    if params[:name].nil? || params[:name] == ""
      render json: {error: "error"}, status: 400
    else
      render json: ItemSerializer.new(Item.search(params[:name]))
    end
  end

  def find_one_item_by_price
    if params[:name] != nil && (params[:max_price] != nil || params[:min_price] != nil)
      render json: {error: "error"}, status: :bad_request
    elsif params[:max_price] != nil && params[:min_price] != nil
      if params[:max_price].to_i > params[:min_price].to_i
        item = Item.search_one_price_range(params[:min_price].to_i, params[:max_price].to_i)
        if item.nil? || item == []
          render json: {error: "error"}, status: 400
        else
          render json: ItemSerializer.new(item)
        end
      else
        render json: {error: "minimum price must be greater than maximum price"}, status: 400
      end
    elsif params[:min_price] != nil
      if params[:min_price].to_i <= 0
        render json: {error: "minimum price must be greater than 0"}, status: 400
      else
        item = Item.search_one_min_price(params[:min_price].to_i)
        if item.class == Item
          render json: ItemSerializer.new(item)
        else
          render json: {data: {}}
        end
      end
    else params[:max_price] != nil
      if params[:max_price].to_i <= 0
        render json: {error: "maximum price must be greater than 0"}, status: 400
      else
        render json: ItemSerializer.new(Item.search_one_max_price(params[:max_price].to_i))
      end
    end
  end
end
