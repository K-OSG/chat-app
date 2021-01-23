class UsersController < ApplicationController

  def edit
  end

  def update
    # form_withにて入力済データが格納されているcurrent_userの保存リクエストがくる
    # updateメソッド時にuser_prams(private)メソッドが呼び出される
    if current_user.update(user_params)
     redirect_to root_path
    else
     render :edit
    end
  end


  private
  def user_params
    # current_user.updateメソッドにて呼び出される
    # 許可されたnameとemailが保存される。
    params.require(:user).permit(:name, :email)
  end
end
