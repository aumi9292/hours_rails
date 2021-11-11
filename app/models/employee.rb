class Employee < ApplicationRecord
  has_many :date_hours

  validates :full_name, presence: true
end
