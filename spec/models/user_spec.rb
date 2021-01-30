require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    before do
      @user = FactoryBot.build(:user)
    end

    it "nameとemail、passwordとpassword_confirmationが存在すれば登録できること" do
      # binding.pry
      expect(@user).to be_valid
    end

    it "nameが空では登録できないこと" do
      @user.name = nil
      @user.valid?
      # binding.pry
      expect(@user.errors.full_messages).to include ("Name can't be blank")
    end

    it "emailが空では登録できないこと" do
      @user.email = nil
      @user.valid?
      # binding.pry
      expect(@user.errors.full_messages).to include ("Email can't be blank")
    end

    it "passwordが空では登録できないこと" do
      @user.password = nil
      @user.valid?
      # binding.pry
      expect(@user.errors.full_messages).to include ("Password can't be blank")
    end

    it "重複したemailが存在する場合登録できないこと" do
      @user.save
      # @userの情報を保存して別のuserのインスタンス作成時に「, email:@user.email」だけを
      # 指定する
      another_user = FactoryBot.build(:user, email:@user.email)
      # another_user = FactoryBot.build(:user) ⇦この記述でも検証はできる
      # another_user.email = @user.email
      another_user.valid?
      # binding.pry
      expect(another_user.errors.full_messages).to include("Email has already been taken")
    end
  end
end
