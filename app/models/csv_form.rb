class CsvForm
  include ActiveModel::Model

  attr_accessor :file

  def read
    data = file.read
    data.force_encoding("utf-8")
    CSV.parse(data) do |row|
      yield row
    end
  end
end