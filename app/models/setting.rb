class Setting < ApplicationRecord
  belongs_to :user

  validates :lang, presence: true
end
