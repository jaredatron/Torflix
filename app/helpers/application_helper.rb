module ApplicationHelper

  def javascript_env
    {
      GIT_SHA: GIT_SHA,
    }
  end

end
