class RoutinesController < ApplicationController

  before_action :find_routine, only: [:show, :update, :edit, :destroy]

  def index
  @routines  = Routine.all
  end

  def show

  end

  def create
    @routine = Routine.create(routine_params)
    if @routine.valid?
      UserBadge.unlocks(@routine)
      @user = User.find_by(id: params["routine"][:user_id])
      redirect_to user_path(@user)
    else
      flash[:error] = @routine.errors.full_messages
      redirect_to new_routine_path
    end
  end

  def update
      @routine = routine.find_by(id: params[:id])
      if @routine.update(routine_params)
        redirect_to user_path
      else
        flash[:errors] = @routine.errors.full_messages
        redirect_to new_routine_path
      end
  end

  def new
    @routine = Routine.new
  end

  def edit

  end

  def destroy
    @routine.destroy
    redirect_to routines_path
  end

  private

  def routine_params
    params.require(:routine).permit(:user_id, :exercise_id, :reps)
  end

  def find_routine
    @routine = Routine.find_by(id: params[:id])
  end
end
