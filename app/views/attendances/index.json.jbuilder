json.array!(@attendances) do |attendance|
  json.extract! attendance, :id, :user_id, :date, :started_at, :ended_at
end
