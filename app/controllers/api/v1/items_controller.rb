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
    if Item.where(id: params[:id]).count > 0
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: {error: "item does not exist with that id"}, status: 404
    end
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def update
    if Item.where(id: params[:id]).count > 0
      if params[:merchant_id].nil?
        render json: ItemSerializer.new(Item.update(params[:id], item_params))
      elsif Merchant.where(id: params[:merchant_id]).count == 0
        render json: {error: "invalid merchant id"}, status: 404
      else
        render json: ItemSerializer.new(Item.update(params[:id], item_params))
      end
    else
      render json: {error: "item does not exist with that id"}, status: 404
    end
  end

  def destroy
    if Item.where(id: params[:id]).count > 0
      render json: Item.delete(params[:id])
      delete_invoices_with_item(params[:id])
    else
      render json: {error: "item does not exist with that id"}, status: 404
    end
  end
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  private

  def delete_invoices_with_item(item_id)
    Invoice.delete_if_only_item(item_id)
  end
end
