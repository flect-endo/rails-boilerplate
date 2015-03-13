class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :authentication_token, uniqueness: true, allow_nil: true
  has_many :notes, dependent: :delete_all
  has_many :user_checklists, dependent: :delete_all
  has_many :attendances, dependent: :delete_all

  def start_work
    Attendance.where(user: self, date: Date.today).first \
    || Attendance.create!(user: self, date: Date.today, started_at: Time.current)
  end

  def end_work
    attendance = Attendance.where(user: self, date: Date.today).first
    raise "not start" if attendance.nil?
    raise "already end" if attendance.ended_at.present?

    attendance.update_attributes!(ended_at: Time.current)
    attendance
  end

  # OAuth 経由で Salesforce ログインしてきた場合のユーザ情報を取得する
  def self.find_or_create_with_omniauth(auth)
    find_or_create_for_auth(auth["provider"], auth["uid"], auth["info"]["email"],
        auth["info"]["name"], auth["info"]["nickname"])
  end

  # Force.com Canvasからの署名付き要求でログインするためのユーザ情報を取得する
  def self.find_or_create_with_signed_request(signed_request)
    context = signed_request['context']
    provider = "salesforce"
    uid = "#{context['links']['loginUrl']}id/#{context['organization']['organizationId']}/#{context['user']['userId']}"

    find_or_create_for_auth(provider, uid, context['user']['userName'], context['user']['userName'])
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

  # Devise のサインアップではなく OAuth などの別経路でユーザがログインしてきた時の処理
  def self.find_or_create_for_auth(provider, uid, email, username, nickname="")
    user = where(provider: provider, uid: uid).first
    return user if user.present?

    user = where(email: email).first
    if user.nil?
      user = User.new(
        email: email,
        password: Devise.friendly_token[0, 20],
        provider: provider,
        uid: uid,
        name: username,
        nickname: nickname
      )
      # メールアドレスの確認はスキップ(Force.com ログイン可能な時点で住んでいるものとみなす)
      user.skip_confirmation!
    elsif user.provider.blank?
      user.provider = provider
      user.uid = uid
      user.name = username
      user.nickname = nickname
    end
    user.save!
    user
  end
end
