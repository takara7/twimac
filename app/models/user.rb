class User < ApplicationRecord
  # Include default devise modules.
  devise :registerable,
         :omniauthable, omniauth_providers: [:twitter]
  include DeviseTokenAuth::Concerns::User

  has_many :authentications
  has_one :setting, autosave: true

  after_initialize :set_default_value, if: :new_record?

  delegate :uid, :provider, to: 'authentications.first', allow_nil: true

  private

  def set_default_value
    setting ||= Setting.new
  end
end
