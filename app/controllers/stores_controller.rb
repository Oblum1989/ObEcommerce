class StoresController < ApplicationController
  include Secured
  
  def index
    @stores = Store.published
    render json: @stores, status: :ok
  end

  def show
    @store = Store.find(params[:id])
    render json: @stores, status: :ok
  end

  def create
    @store = Store.new(create_params)

    if @store.save
      render json: @store, status: :created
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  def update
    @store = Store.find(params[:id])
    if @store.update(update_params)
      render json: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @store = Store.find(params[:id])
    @store.destroy
  end

  private

    def create_params
      params.require(:store).permit(:name, :description, :link, :address, :contact_phones, :email)
    end

    def update_params
      params.require(:store).permit(:name, :description, :link, :address, :contact_phones, :email, :active)
    end

end
