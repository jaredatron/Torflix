class Show < ActiveRecord::Base

  include NormalizedNameConcern

  has_many :episodes, dependent: :destroy

  def as_json(options={})
    return super if options.empty?
    super include: [:episodes]
  end

end
