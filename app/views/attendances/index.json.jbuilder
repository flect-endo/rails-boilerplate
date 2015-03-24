json.array!(@attendances) do |attendance|
  json.extract! attendance, :id, :user_id
  json.date attendance.try(:utc) || 0
  json.started_at attendance.try(:utc) || 0
  json.ended_at attendance.try(:utc) || 0
end
