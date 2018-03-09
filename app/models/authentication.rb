class Authentication < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :user_id, presence: true
  validates :token, presence: true
  validates :token_secret, presence: true

  class << self
    def find_or_create_by_omniauth(auth, user)
      model = find_or_initialize_by(uid: auth.uid, provider: auth.provider)
      credentials = auth.credentials
      model.token = credentials.token
      model.token_secret = credentials.secret
      transaction do
        unless model.user
          unless user
            user = User.new
            user.save!(validate: false)
          end
          user.authentications << model
        end
      end
      model
    end
  end
end
