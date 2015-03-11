class UserChecklist < ActiveRecord::Base
  belongs_to :user
  # 外部キー参照でなく、項目名をそのまま保持するようにした方がよいかも
  belongs_to :checklist
end
