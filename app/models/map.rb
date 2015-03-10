class Map
  include ActiveModel::Model

  attr_accessor :file

  def initialize(attributes={})
    original_filename
  end
end
