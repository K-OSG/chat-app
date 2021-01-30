class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one_attached :image
  validates :content, presence: true, unless: :was_attached?
  # unlessオプションで:「was_attached?メソッド」の返り値がfalseなら
  # バリデーションによる検証を行う = trueならバリデーションの検証なし
  # belongs_toは外部キーに対してはデフォルトで空の検証バリデーションが働いている

  # メソッドは同じクラス内にselfで定義
  def was_attached?
    # unlessで使うメソッドの定義。
    self.image.attached?
    # 画像があればattached?でtrue = persence: trueが働かずにテキストが空でも送信可能
    # 画像なしだとfalse = persence: trueで検証されてテキストが空では送信出来ない
  end
end
