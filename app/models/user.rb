class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :authentication_token, uniqueness: true, allow_nil: true
  has_many :notes, dependent: :delete_all

  # OAuth 経由で Salesforce ログインしてきた場合のユーザ情報を取得する
  def self.find_or_create_with_omniauth(auth)
    user = where(provider: auth["provider"], uid: auth["uid"]).first
    if user.nil?
      user = User.new(
        email: auth["info"]["email"],
        # FIXME: Devise デフォルトの encrypted_password を回避するための応急処置
        password: "password",
        password_confirmation: "password",

        provider: auth["provider"],
        uid: auth["uid"],
        name: auth["info"]["name"],
        nickname: auth["info"]["nickname"]
      )
      # メールアドレスの確認はスキップ(Force.com ログイン可能な時点で住んでいるものとみなす)
      user.skip_confirmation!
      user.save!
    end
    user
  end

  # Force.com Canvasからの署名付き要求でログインするためのユーザ情報を取得する
  def self.find_or_create_with_signed_request(signed_request)
    context = signed_request['context']
    provider = "salesforce"
    uid = "#{context['links']['loginUrl']}id/#{context['organization']['organizationId']}/#{context['user']['userId']}"

    user = where(provider: provider, uid: uid).first
    if user.nil?
      user = User.new(
        email: context['user']['userName'],
        # FIXME: Devise デフォルトの encrypted_password を回避するための応急処置
        password: "password",
        password_confirmation: "password",
        provider: "salesforce",
        uid: uid,
        name: context['user']['userName']
      )
      # メールアドレスの確認はスキップ(Force.com ログイン可能な時点で住んでいるものとみなす)
      user.skip_confirmation!
      user.save!
    end
    user
  end

  def logged_in_from_salesforce?
    # モデルから session にアクセスできないため
    salesforce_provider? # && session[:restforce].present?
  end

  def salesforce_provider?
    provider === "salesforce"
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
