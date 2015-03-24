json.array!(@attendances) do |attendance|
  json.extract! attendance, :id, :user_id
  json.date Time.parse(attendance.date.to_s).to_i
  json.started_at attendance.started_at.to_i
  if json.ended_at.present?
    json.ended_at attendance.ended_at.to_i
  end
end
