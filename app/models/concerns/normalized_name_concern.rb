module NormalizedNameConcern
  extend ActiveSupport::Concern

  class_methods do

    def normalize_name(name)
      name.downcase.gsub(%r{\s*\(\d{4}\)},'').gsub(/[^a-z0-9 ]/,'')
    end

  end

  included do
    scope :by_name, ->(name){
      where(normalized_name: self.normalize_name(name))
    }
  end

  def name=(name)
    super
    self.normalized_name = name
  end

  def normalized_name=(name)
    super self.class.normalize_name(name)
  end


end