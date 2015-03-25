class Map
  include ActiveModel::Model

  attr_accessor :tracks

  def initialize(attributes={})
    super
  end
end