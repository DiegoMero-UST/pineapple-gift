class GiftLink < ApplicationRecord
  has_one :submission, dependent: :destroy
  
  validates :token, presence: true, uniqueness: true
  validates :used, inclusion: { in: [true, false] }
  
  scope :unused, -> { where(used: false) }
  scope :used, -> { where(used: true) }
  
  def mark_as_used!
    update!(used: true)
  end
  
  def used?
    used
  end
end
