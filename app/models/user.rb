class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable, :registerable
  # :recoverable, :database_authenticatable, :validatable,
  devise :trackable, :omniauthable, :rememberable,
         :omniauth_providers => [:wechat]

  # ==========================================================================
  # USER RELATION
  # ==========================================================================

  has_many :authorizations, dependent: :destroy

  # ==========================================================================
  # USER ATTRIBUTE OPERATION AND VALIDATION
  # ==========================================================================

  # Email Operation
  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :email,
            presence: true,
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  # Phone Operation (only number is allowed)
  VALID_PHONE_REGEX = /\A[+-]?\d+\Z/
  validates :phone,
            presence: true,
            format: {with: VALID_PHONE_REGEX,
                     message: :number},
            uniqueness: true

  # Country code Operation
  VALID_COUNTRY_CODE_REGEX = /[+]\d+/
  validates :country_code,
            presence: true,
            format: {with: VALID_COUNTRY_CODE_REGEX,
                     message: :number}

  # ==========================================================================
  # Devise FUNCTIONS
  # ==========================================================================

  # Use in +OmniauthCallbacksController+, create the user
  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(
        :provider => auth.provider,
        :uid => auth.uid.to_s).first_or_initialize
    if authorization.user.blank?
      user = current_user || User.where('email = ?', auth.info.email).first
      if user.blank?
        user = User.new
        user.nickname = auth.info.nickname
        user.sex = auth.info.sex
        user.avatar = auth.info.headimgurl
        user.save(:validate => false)
      end
    authorization.user_id = user.id
    authorization.save
    end
    authorization.user
  end

  # ==========================================================================
  # One-time password (OTP) FUNCTIONS
  # ==========================================================================

  # Check if the user has been activated or not
  #
  #   Return:
  #     true  => user has been activated
  #     false => user hasn't been activated
  def otp_validate?
    self.otp_activation_status
  end

  # Generate a random 4 digits number and update the +otp_code+ attribute, send
  # the code through +SendSmsJob+
  #
  #   Return:
  #     true  => successfully update the +otp_code+ attribute
  #     false => fail to update the +otp_code+ attribute
  def send_otp_code?
    number = rand.to_s[2..5]
    return false unless self.update_attribute(:otp_code, number)
    SendSmsJob.perform_later self.country_code, self.phone, self.otp_code
    return true
  end

  private

  # Change the email characters to lowercase
  def downcase_email
    if !self.email.nil?
      self.email = email.downcase
    end
  end
end
