class ShowsController < ApplicationController

  def index
    render json: Show.all
  end

  def search
    render json: Show.search(params[:q])
  end

  def show
    render json: Show.find(params[:id])
  end

  def art
    redirect_to Show.art(params[:show_name])
  end

end
