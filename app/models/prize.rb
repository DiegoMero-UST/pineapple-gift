class Prize < ApplicationRecord
  has_many :submissions, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
