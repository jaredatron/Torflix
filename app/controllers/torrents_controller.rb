class TorrentsController < ApplicationController

  def search
    query = params[:q]
    render json: Torrent.search(query)
  end

end
