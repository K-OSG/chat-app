require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do
    before do
      @message = FactoryBot.build(:message)
    end

    it 'contentとimageが存在していれば保存できること' do
      # binding.pry
      expect(@message).to be_valid
    end

    it 'contentが空でも保存できること' do
      @message.content = nil
      # @message.valid?
      # binding.pry
      expect(@message).to be_valid
    end

    it 'imageが空でも保存できること' do
      @message.image = nil
      expect(@message).to be_valid
    end

    it 'contentとimageが空では保存できないこと' do
      @message.content = nil
      @message.image = nil
      @message.valid?
      # binding.pry
      expect(@message.errors.full_messages).to include("Content can't be blank")
    end

    it 'roomが紐付いていないと保存できないこと' do
      # 外部の紐付け値は@messageでは確認出来ないので「@message.モデル名」で紐付け値を取得して確認
      # nilを代入して空にして@message.roomにて中身を確認してvalid?をかけてfalseを返り値として得る
      @message.room = nil
      @message.valid?
      # binding.pry
      expect(@message.errors.full_messages).to include("Room must exist")
      # エラー内容を配列形式なのでincludeメソッドにて配列内に期待した文字が含まれているかを検証
    end

    it 'userが紐付いていないと保存できないこと' do
      @message.user = nil
      @message.valid?
      # binding.pry
      expect(@message.errors.full_messages).to include("User must exist")
    end
  end
end