class Show < ActiveRecord::Base

  def self.normalize_name(name)
    name.downcase.gsub(%r{\s*\(\d{4}\)},'').gsub(/[^a-z0-9 ]/,'')
  end

  has_many :episodes

  scope :by_name, ->(name){
    where(normalized_name: self.normalize_name(name)).first
  }

  def as_json(options={})
    return super if options.empty?
    super include: [:episodes]
  end

  def name=(name)
    super
    self.normalized_name = name
  end

  def normalized_name=(name)
    super self.class.normalize_name(name)
  end

end
