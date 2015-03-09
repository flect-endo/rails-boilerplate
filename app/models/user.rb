class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :authentication_token, uniqueness: true, allow_nil: true
  has_many :notes

  def self.create_with_omniauth(auth)
    create! do |user|
      user.email = auth["info"]["email"]
      # FIXME: Devise デフォルトの encrypted_password を回避するための応急処置
      user.password = user.password_confirmation = "password"

      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.nickname = auth["info"]["nickname"]
    end
  end

  def active_for_authentication?
    # FIXME: メールアドレスを確認していなくてもログインできてしまうので、回避
    # Devise の confirmable.rb を見ると、メール送信日時しか評価しておらず、実際に確認が取れてなくても
    # この値が true を返してしまうことで、メール確認済みと評価されてしまうので、判定を除外する
    super && (!confirmation_required? || confirmed?) #  || confirmation_period_valid?)
  end

  def after_confirmation
    super
    ensure_authentication_token
  end

  def ensure_authentication_token
    self.authentication_token || generate_authentication_token
  end

  def generate_authentication_token
    loop do
      old_token = self.authentication_token
      token = SecureRandom.urlsafe_base64(24).tr('lIO0', 'sxyz')
      break token if (self.update!(authentication_token: token) rescue false) && old_token != token
    end
  end

  def delete_authentication_token
    self.update(authentication_token: nil)
  end
end
