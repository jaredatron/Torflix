class Episode < ActiveRecord::Base

  include NormalizedNameConcern

  belongs_to :show

  before_validation :extract_episode_number!

  private

  def extract_episode_number!
    if name.match(/(\d+)x(\d+)/i) || name.match(/S(\d+)E(\d+)/i)
      self.season_number = $1.to_i
      self.seasonal_episode_number = $2.to_i
      self.episode_number = (
        self.season_number.to_s.ljust(3,'0').to_i +
        self.seasonal_episode_number
      )
    end
  end

end
