class RoomsController < ApplicationController
  def index
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    # Roomモデルから個別指定データを取り出す記述
    # モデル→コントローラー、コントローラー→モデルのデータの受け渡しはparams使用
    room = Room.find(params[:id])
    room.destroy
    redirect_to root_path
  end

  private
  def room_params
    params.require(:room).permit(:name, user_ids: [])
  end
end