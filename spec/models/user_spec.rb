require 'rails_helper'

describe User do
  let(:valid_user) { build(:user) }

  it 'should have a valid factory' do
    expect(valid_user.valid?).to be true
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end

  describe 'has_secure_password' do
    it { should have_secure_password }
  end
end
