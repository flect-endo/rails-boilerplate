class CsvForm
  include ActiveModel::Model

  attr_accessor :file, :filename

  def initialize(attributes={})
    super
    @filename ||= file.try(:original_filename)
  end

  def read
    data = file.read
    data.force_encoding("utf-8")
    CSV.parse(data) do |row|
      yield row
    end
  end
end