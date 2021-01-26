class MessagesController < ApplicationController
  def index
    @message = Message.new
    # メッセージにはルームidが親関係として必要となるためfindメソッドにてroomモデルから取得
    # この時paramsは配列の値をハッシュ形式で保存しているためキーの指定は配列となる
    @room = Room.find(params[:room_id])
  end

  def create
    # まず保存する時にはルームレコード(親情報)が必要なのでfindにて取得したroom_idを代入
    @room = Room.find(params[:room_id])
    # 次に代入した変数に対して『.messages.new』のインスタンスをつけることにより
    # 親関係に紐づいたインスタンスの生成が可能となりmessage_paramsを呼び出す。
    @message = @room.messages.new(message_params)
    # privateメソッドにて許可した値を@messageに代入してsaveで保存する
    if @message.save
      # @room変数を持たせることによりredirect_toでコントローラーのindexアクション
      # に再度リクエストして新たにインスタンス変数を生成する
      redirect_to room_messages_path(@room)
    else
      render :index
    end
  end

  private
  # ストロングパラメーターの設定
  def message_params
    # messageモデルに対してcurrent_user.idを紐付けしたcontentのみ保存を許可する
    # mergeはparamaにおいては紐付けの意味をはたす
    params.require(:message).permit(:content).merge(user_id: current_user.id)
    # .permit(保存値(カラム名)).merge(保存先カラム(キー): 紐付けするデータ)
    # user_id:(保存先カラム)としてcurrent_user.idの値を紐付けられたcontentのみ保存を許可
  end
end