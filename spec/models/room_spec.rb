require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#create' do
    before do
      @room = FactoryBot.build(:room)
    end

    it "nameの値が存在すれば登録できること" do
      # binding.pry
      expect(@room).to be_valid
    end

    it "nameが空では登録できないこと" do
      @room.name = nil
      # binding.pry
      @room.valid?
      expect(@room.errors.full_messages).to include("Name can't be blank")
    end
  end
end