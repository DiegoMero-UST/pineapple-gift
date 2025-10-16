class Submission < ApplicationRecord
  belongs_to :gift_link
  belongs_to :prize
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :zip, presence: true
  
  validate :gift_link_not_already_used
  
  after_create :mark_gift_link_as_used
  
  private
  
  def gift_link_not_already_used
    if gift_link&.used?
      errors.add(:gift_link, "has already been used")
    end
  end
  
  def mark_gift_link_as_used
    gift_link.mark_as_used!
  end
end
