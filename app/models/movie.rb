class Movie < ActiveRecord::Base
  def self.get_all_ratings
    self.uniq.pluck(:rating)
  end
end
