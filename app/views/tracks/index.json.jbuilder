json.array!(@tracks) do |track|
  json.extract! track, :id
  json.size track.size
end