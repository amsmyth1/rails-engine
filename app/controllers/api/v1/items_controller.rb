class Api::V1::ItemsController < ApplicationController
  include ActionController::Helpers

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
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    render json: Item.delete(params[:id])
  end
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
