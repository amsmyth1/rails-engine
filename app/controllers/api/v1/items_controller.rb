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
end
