class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  def ability
    @ability ||= Ability.new(self)
  end

  delegate :can?, to: :ability
end
