class TorrentsController < ApplicationController

  def search
    render json: Torrent.search(params[:q])
  end

  def show
    render json: Torrent.find(params[:id])
  end

end
