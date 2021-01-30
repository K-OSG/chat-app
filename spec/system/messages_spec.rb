require 'rails_helper'

RSpec.describe "メッセージ投稿機能", type: :system do
  before do
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    @room_user = FactoryBot.create(:room_user)
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗すること' do
      # サインインする
      # sign_in_supprt.rb内にて定義したインスタンス
      # beforeにて中間テーブルに作成された@room_userの.userでサインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      # @room_userにて作成されたroom.nameをクリックする
      click_on(@room_user.room.name)

      # DBに保存されていないことを確認する
      # .toを.not_toにすると後述マッチャの意味が反対になる
      # {find('input[name = "commit"]').click}でcommitのnameをクリックすると得られる実際値となる
      expect{find('input[name = "commit"]').click}.not_to change{Message.count}
      # 元のページに戻ってくることを確認する
      # (@room_user.room)を引数にしないと戻る部屋が見つからないので指定する
      expect(current_path).to eq room_messages_path(@room_user.room)
    end
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 値をテキストフォームに入力する
      # 仮テストデータをpostとして代入、postをfill_inで入力させる
      # のちのhave_contentマッチャによる確認に使うため
      post = "テスト"
      fill_in 'message_content', with: post

      # 送信した値がDBに保存されていることを確認する
      expect{find('input[name = "commit"]').click}.to change { Message.count }.by(1)

      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)

      # 送信した値がブラウザに表示されていることを確認する
      # have_contentマッチャにて入力したpostが存在するか確認
      # pageはビューファイルを取得するため、have_contentでpostを探す
      expect(page).to have_content(post)
    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する

      # Rails.rootで絶対パスを取得してjoinメソッドで()内の引数を繋げる
      # Rails.root.join(AP内のトップディレクトリからファイル名までの相対パス)でファイルパス取得できる
      # 取得した物は変数に代入してattach_fileにて使用する
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する

      # attach_fileは「input要素のtype=file」における画像投稿するテストコードメソッド
      # ()内に第一引数、第二引数、第三引数と指定する
      # 第一引数：投稿するinput要素のname属性
      # 第二引数：投稿するファイルパス（ファイル定義をimage_pathに代入）
      # 第三引数：class=hiddenに対して指定するオプション
      attach_file("message[image]", image_path, make_visible: true)
      # 送信した値がDBに保存されていることを確認する
      expect{find('input[name = "commit"]').click}.to change { Message.count }.by(1)
      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
      # 送信した画像がブラウザに表示されていることを確認する
      # binding.pry
      expect(page).to have_selector("img")
      # have_selectorは検証ツールの画像イメージ部のタグ内最初の文字を指定
      # 最初の文字があっていれば残りもあっていると判断される
    end

    it 'テキストと画像の投稿に成功すること' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)

      # 値をテキストフォームに入力する
      text = "テキスト"
      fill_in 'message_content', with: text
      # 送信した値がDBに保存されていることを確認する
      expect{find('input[name = "commit"]').click}.to change{Message.count}.by(1)

      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(text)
      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector('img')
    end
  end
end

RSpec.describe "チャットルームの削除機能", type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
  end

  it 'チャットルームを削除すると、関連するメッセージがすべて削除されていること' do
    # サインインする
    sign_in(@room_user.user)

    # 作成されたチャットルームへ遷移する
    click_on(@room_user.room.name)

    # メッセージ情報を5つDBに追加する
    # FactoryBot.create_listでMessageモデルに対して５つのレコードを作成する
    # その時にroom_id: @room_user.room.id, user_id: @room_user.user.idを紐付ける
    FactoryBot.create_list(:message, 5, room_id: @room_user.room.id, user_id: @room_user.user.id)

    # 「チャットを終了する」ボタンをクリックすることで、作成した5つのメッセージが削除されていることを確認する
    expect{find_link("チャットを終了する", href:room_path(@room_user.room)).click}.to change{@room_user.room.messages.count}.by(-5)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
  end
end