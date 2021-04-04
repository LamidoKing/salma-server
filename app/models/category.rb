class Category < ApplicationRecord
  has_many :helps

  validates :name, presence: true
  validates :color, presence: true
end