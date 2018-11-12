class UsersController < ApplicationController

  before_action :find_user, only: [:show, :update, :edit, :destroy]

  def index
  @users  = User.all
  end

  def show

  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages
      redirect_to new_user_path
    end
  end

  def update
      @user = User.find_by(id: params[:id])
      if @user.update(user_params)
        redirect_to user_path(@user)
      else
        flash[:errors] = @user.errors.full_messages
        redirect_to new_manager_path
      end
  end

  def new
    @user = User.new
  end

  def edit

  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :weight, :mood)
  end

  def find_user
    @user = User.find_by(id: params[:id])
  end
end
