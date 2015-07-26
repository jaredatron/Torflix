class AppController < ActionController::Base

  def show
    respond_to do |r|
      r.html {}
      r.any{ render nothing: true, status: :not_found }
    end
  end

end
