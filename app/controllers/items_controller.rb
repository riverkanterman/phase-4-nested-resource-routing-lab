class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_errors
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_errors

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    user = User.find(params[:user_id])
    item = user.items.find(params[:id])
    render json: item, include: :user
  end

  def create 
    user = User.find(params[:user_id])
    item = user.items.create!(items_params)
    render json: item, include: :user, status: :created
  end 

  private 

  def items_params
    params.permit(:name, :description, :price)
  end

  def not_found_errors
    render json: {error:'User not found'}, status: :not_found
  end

  def invalid_errors
    render json: {error:'Item cannot be created'}, status: :unprocessable_entity
  end

end
