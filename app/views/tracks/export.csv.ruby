require 'csv'
CSV.generate do |csv|
  @track.trackpoints.each do |trackpoint|
    csv << [trackpoint["lat"], trackpoint["lng"]]
  end
end
