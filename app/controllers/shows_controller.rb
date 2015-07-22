class ShowsController < ApplicationController

  def index
    # shows = Show.all.as_json.each do |show|
    #   show['artwork_url'] ||= view_context.image_path('blank.gif')
    # end
    render json: Show.all.includes(:episodes)
  end

  def search
    render json: Show.search(params[:q])
  end

  def show
    render json: Show.find(params[:id])
  end

end
