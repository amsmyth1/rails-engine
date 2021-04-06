class Api::V1::ItemsController < ApplicationController

  def index
    if params[:page] == "0"
      render json: ItemSerializer.new(Item.all.paginate(page: 1, per_page: params[:per_page]))
    else
      render json: ItemSerializer.new(Item.all.paginate(page: params[:page], per_page: params[:per_page]))
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: Item.create(item_params)
    # Item.new!({
    #   name: params[:item][:name],
    #   description: params[:item][:description],
    #   price: params[:item][:price],
    #   merchant_id: params[:item][:merchant_id],
    #   })
    #   binding.pry
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
