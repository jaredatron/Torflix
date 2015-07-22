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
    image_url = Show.art(params[:show_name])
    redirect_to image_url || view_context.image_path('blank.gif')
  end

end
