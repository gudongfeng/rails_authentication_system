require 'rails_helper'

RSpec.describe Authorization, type: :model do

  before do
    @auth = Authorization.create(uid: 12345, provider: 'wechat')
  end

  describe '#Creation' do
    it 'can be created' do
      expect(Authorization.count).to eql 1
      expect(@auth).to be_valid
    end

    it 'can be created with associated user' do
      user = User.create(email: 'test@test.com', phone: '99999999',
                         country_code: '+86')
      expect(user).to be_valid
      user.authorizations.create(uid: 3456, provider: 'wechat')
      expect(Authorization.last.uid).to eql '3456'
    end

    it 'can not be created without uid' do
      @auth.uid = nil
      expect(@auth).to_not be_valid
    end

    it 'can not be created without provider' do
      @auth.provider = nil
      expect(@auth).to_not be_valid
    end

    it 'can not be created with same uid' do
      auth2 = Authorization.create(uid: 12345, provider: 'facebook')
      expect(auth2).to_not be_valid
      expect(Authorization.count).to eql 1
    end
  end

  describe '#Destroy' do
    it 'can be destroy' do
      expect(Authorization.count).to eql 1
      @auth.destroy
      expect(Authorization.count).to eql 0
    end

    it 'can be destroy when we destroy the corresponding user' do
      user = User.create(email: 'test@test.com', phone: '99999999',
                         country_code: '+86')
      @auth.user = user
      @auth.save
      expect(User.count).to eql 1
      expect(user.id).to eql @auth.user_id
      user.destroy
      expect(User.count).to eql 0
      expect{ @auth.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe '#Association' do
    it 'has belongs to association' do
      assc = Authorization.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end
  end
end