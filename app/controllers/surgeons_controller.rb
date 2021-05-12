class SurgeonsController < ApplicationController
  def index
    if params[:location_id]
      @location = Location.find(params[:location_id])
      @surgeons = Surgeon.search_by_location(params[:search], @location.id).paginate(:page => params[:page], :per_page => 30)
    elsif params[:user_id]
      #show surgeons for a location
      @location = Location.find_by_user_id(params[:user_id])
      @surgeons = Surgeon.search_by_location(params[:search], @location.id).paginate(:page => params[:page], :per_page => 30) if @location
    else
      if current_user && current_user.admin?
        @surgeons = Surgeon.search(params[:search]).paginate(:page => params[:page], :per_page => 30) #show all surgeons
      elsif current_user && current_user.manager?
        @location = Location.find_by_user_id(current_user.id)
        @surgeons = Surgeon.search_by_location(params[:search], @location.id).paginate(:page => params[:page], :per_page => 30) if @location
      end
    end
  end

  def new
    @location = Location.find(params[:location_id])
    @surgeon = @location.surgeons.new
    # params[:url] = @location.website
    # params[:phone] = @location.phone_number
  end

  def create
    @surgeon = Surgeon.new(params_surgeon)
    #    @surgeon.status = "publish" if current_user && current_user.admin?
    if @surgeon.save
      if current_user && current_user.manager?
        @admins = User.where("role = ? and deleted_at is NULL", "admin")
        @admins.each do |admin|
          NotificationMailer.added_surgeons_email(@surgeon, admin.email).deliver_now
        end
        flash[:notice] = "Surgeon has been successfully created. Admin will verify and approve the surgeon."
        redirect_to surgeons_path(:user_id => current_user.id)
      elsif current_user && current_user.admin?
        flash[:notice] = "Surgeon has been successfully created."
        redirect_to surgeons_path
      end
    else
      render "new"
    end
  end

  def show
    @surgeon = Surgeon.find(params[:id])
    @location = Location.find(@surgeon.location_id)
  end

  def edit
    @surgeon = Surgeon.find(params[:id])
    @location = Location.find(@surgeon.location_id)
  end

  def update
    @surgeon = Surgeon.find(params[:id])
    @location = Location.find(@surgeon.location_id)
    if @surgeon.update(params_surgeon)
      flash[:notice] = "Surgeon has been successfully updated."
      redirect_to surgeons_path
    else
      render "edit"
    end
  end

  def destroy
    @surgeon = Surgeon.find(params[:id])
    @surgeon.destroy
    flash[:notice] = "Surgeon has been successfully deleted."
    redirect_to surgeons_path
  end

  #make the surgeon status from private to publish
  #  def set_status
  #    if current_user && current_user.admin?
  #      @surgeon = Surgeon.find(params[:id])
  #      @surgeon.update_column(:status, "publish")
  #      flash[:notice] = "Surgeon has been successfully made live."
  #    else
  #      flash[:notice] = "Sorry. Only admin has the rights to make a surgeon live."
  #    end
  #    redirect_to surgeons_path
  #  end

  private

  def params_surgeon
    params.require(:surgeon).permit(:location_id, :full_name, :email, :suffix, :url, :phone, :status, :procedure_types_array => [])
  end
end
