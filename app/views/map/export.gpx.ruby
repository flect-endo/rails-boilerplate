require 'csv'
CSV.generate do |csv|
  @tracks.each do |track|
    csv << [track["lat"], track["lng"]]
  end
end