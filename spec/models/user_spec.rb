require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = User.create(email: 'test@test.com',
                        phone: '99999999',
                        country_code: '+86')
  end

  describe '#Creation' do
    it 'can be created' do
      expect(@user).to be_valid
    end

    it 'can not be created without phone' do
      @user.phone = nil
      expect(@user).to_not be_valid
    end

    it 'can not be created with invalid phone type' do
      @user.phone = 'asdlfkjoiquwer'
      @user.save
      expect(@user.errors.full_messages).to eql ["Phone必须为数字"]
      expect(@user).to_not be_valid
    end

    it 'can not be created without country code' do
      @user.country_code = nil
      expect(@user).to_not be_valid
    end

    it 'can not be created with invalid country code' do
      @user.country_code = 'invalid'
      @user.save
      expect(@user.errors.full_messages).to eql ["Country code格式必须为 +123"]
      expect(@user).to_not be_valid
    end

    it 'can not be created without email' do
      @user.email = nil
      expect(@user).to_not be_valid
    end

    it 'can not be created with invalid email' do
      @user.email = 'invalid'
      @user.save
      expect(@user.errors.full_messages).to eql ["Email是无效的"]
      expect(@user).to_not be_valid
    end
  end

  describe '#Destroy' do
    it 'can be destroy' do
      expect(User.count).to eql 1
      @user.destroy
      expect(User.count).to eql 0
    end
  end

  describe '#Association' do
    it 'has multiple association' do
      assc = User.reflect_on_association(:authorizations)
      expect(assc.macro).to eq :has_many
    end
  end
end