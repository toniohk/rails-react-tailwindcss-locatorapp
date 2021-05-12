class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(params_user)
      flash[:notice] = "User has been successfully edited."
      redirect_to users_path
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.update_attribute(:deleted_at, Time.current)
    flash[:notice] = "User has been successfully deleted."
    redirect_to users_path
  end

  private

  def params_user
    params.require(:user).permit(:email, :full_name, :role)
  end
end
