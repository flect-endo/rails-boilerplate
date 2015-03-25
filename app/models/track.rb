class Track < ActiveRecord::Base

  def size
    JSON.parse(trackpoints).size
  end
end
