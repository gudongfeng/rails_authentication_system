class Authorization < ActiveRecord::Base
  # ==========================================================================
  # AUTHORIZATION RELATION
  # ==========================================================================

  belongs_to :user

  # ==========================================================================
  # AUTHORIZATION ATTRIBUTE OPERATION AND VALIDATION
  # ==========================================================================

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: true

  # ==========================================================================
  # AUTHORIZATION CALLBACK
  # ==========================================================================

  after_create :fetch_details

  # ==========================================================================
  # AUTHORIZATION FUNCTIONS
  # ==========================================================================

  def fetch_details
    self.send("fetch_details_from_#{self.provider.downcase}")
  end


  def fetch_details_from_wechat

  end
end
