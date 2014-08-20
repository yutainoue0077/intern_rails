class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :signed_in_user_after, only: [:create, :new]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def destroy
    unless User.find(params[:id]) == current_user
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    else
      redirect_to root_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "入力お疲れさまです。無事に登録されました。"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "更新が完了しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit( :name,
                                    :email,
                                    :password,
                                    :password_confirmation)
    end

    def signed_in_user
      unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
      end
    end

    def signed_in_user_after
      if signed_in?
      redirect_to root_path, notice: "hogehoge"
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
