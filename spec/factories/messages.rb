FactoryBot.define do
  factory :message do
    content {Faker::Lorem.sentence}
    association :user
    association :room

    after(:build) do |message|
    # afterメソッドは任意の処理後に指定した処理を実行するメソッド
    # build(Factorybotの生成メソッド)された後に
    # message.imageにてファイルにアクセスしてattachにて保存
    # io: Fileopenで('ファイル先path')を指定,filename('開くファイルの名前')を指定
    # 指定したファイルをFactoryBot後に紐付けて保存する
      message.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
