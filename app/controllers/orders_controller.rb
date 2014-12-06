class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def index
    @orders = Order.all
    respond_with(@orders)
  end

  def show
    respond_with(@order)
  end

  def new
    @order = Order.new
    @listing = Listing.find(params[:listing_id])
    respond_with(@order)
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    # Getting order data
    @listing = Listing.find(params[:listing_id])
    @seller = @listing.user

    # Setting order data
    @order.listing_id = @listing.id
    @order.seller_id = @seller.id
    @order.buyer_id = current_user.id

    @order.save

    # Setting notice and redirecting
    flash[:notice]='Order was successfully created' if @order.save

    respond_with(@order, :location => root_url)
  end

  def update
    @order.update(order_params)
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:address, :city, :state)
    end
end
