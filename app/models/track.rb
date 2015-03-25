class Track < ActiveRecord::Base

  serialize :trackpoints

  def size
    trackpoints.size
  end
end
