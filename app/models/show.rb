class Show < ActiveRecord::Base

  has_many :episodes

  def as_json(options={})
    return super if options.empty?
    super include: [:episodes]
  end

end
