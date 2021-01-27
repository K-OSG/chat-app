class Room < ApplicationRecord
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  has_many :messages, dependent: :destroy
  # dependentは依存の意味。親モデルと挙動を合わせる指定
  validates :name, presence: true
end
