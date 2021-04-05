class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all.paginate(page: params[:page], per_page: params[:per_page]))
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end
end
