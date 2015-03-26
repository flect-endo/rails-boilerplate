require 'gpx'
class Track < ActiveRecord::Base
  serialize :trackpoints

  attr_accessor :line_color

  def size
    trackpoints.size
  end

  def to_gpx
    gpx_file = GPX::GPXFile.new
    track = GPX::Track.new(name: "My Track")
    segment = GPX::Segment.new

    segment.points = trackpoints.map do |trackpoint|
      GPX::TrackPoint.new(lat: trackpoint["lat"], lon: trackpoint["lng"], time: Time.current)
    end
    track.segments << segment
    gpx_file.tracks << track

    gpx_file.to_s
  end
end
