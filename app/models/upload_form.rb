class UploadForm
  include ActiveModel::Model

  attr_accessor :file, :filename

  def initialize(attributes={})
    super
    @filename ||= file.try(:original_filename)
  end

  # TODO: file.read を呼ぶとバッファがリセットされるため、
  # 2回目以降は空のデータが返ってくる。
  # この辺の動作が追いにくいので、エラー処理を追加しときたい。

  def read_data
    file.read
  end

  def read_csv
    data = file.read
    data.force_encoding("utf-8")
    CSV.parse(data) do |row|
      yield row
    end
  end
end