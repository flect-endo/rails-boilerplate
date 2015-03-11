class Checklist < ActiveRecord::Base
  has_many :user_checklists, dependent: :delete_all

  validates_presence_of :title
end
