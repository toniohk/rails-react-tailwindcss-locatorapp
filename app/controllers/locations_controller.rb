class LocationsController < ApplicationController

  def index
    @locations = Location.search(params[:search]).order(created_at: :desc).paginate(page: params[:page], per_page: 30) if current_user.admin?
    if current_user && current_user.manager?
      @my_location = Location.find_by_user_id(current_user.id)
      @locations = current_user.locations.paginate(page: params[:page], per_page: 30)
    end
  end

  def show
    @location = Location.find(params[:id])
  end

  def new
    @my_location = Location.find_by_user_id(current_user.id) if current_user && current_user.manager?
    unless @my_location
      @location = Location.new
    else
      flash[:notice] = "You are the client manager of a location, so you can't add more location(s)."
      redirect_to locations_path
    end
  end

  #save/create location and then save the surgeon details
  def create
    @location = Location.new(params_location)
    @location.user_id = current_user.id
    #    @location.status = "publish" if current_user && current_user.admin?
    if @location.save
      full_location = @location.city + ", "+ CS.states(:us)[@location.state.to_sym] + ", " +@location.country
      latitude, longitude = Geocoder.search(full_location)&.first&.coordinates
      @location.update_attributes(longitude: longitude, latitude: latitude)
      
      if current_user && current_user.manager?
        @admins = User.where("role = ? and deleted_at is NULL", "admin")
        @admins.each do |admin|
          NotificationMailer.added_location_email(@location, admin.email).deliver_now
        end
        flash[:notice] = "Location has been successfully created. Admin will verify and approve the location."
      elsif current_user && current_user.admin?
        flash[:notice] = "Location has been successfully created."
      end
      redirect_to locations_path
    else
      render "new"
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    # Geokit::Geocoders::GoogleGeocoder.api_key = Rails.application.secrets.google_maps_api_key
    # location = Location.last.city + ", "+ CS.states(:us)[Location.last.state.to_sym] + ", " + Location.last.country
    # coords = MultiGeocoder.geocode(location)

    @location = Location.find(params[:id])
    if @location.update(params_location)
      full_location = @location.city + ", "+ CS.states(:us)[@location.state.to_sym] + ", " +@location.country
      latitude, longitude = Geocoder.search(full_location)&.first&.coordinates
      @location.update_attributes(longitude: longitude, latitude: latitude)
      flash[:notice] = "Location has been successfully updated."
      redirect_to locations_path
    else
      render "edit"
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    flash[:notice] = "Location has been successfully deleted."
    redirect_to locations_path
  end

  #make the location status from private to publish
  #  def set_status
  #    if current_user && current_user.admin?
  #      @location = Location.find(params[:id])
  #      @location.update_column(:status, "publish")
  #      flash[:notice] = "Location has been successfully made live."
  #    else
  #      flash[:notice] = "Sorry. Only admin has the rights to make a location live."
  #    end
  #    redirect_to locations_path
  #  end

  private

  def params_location
    params.require(:location).permit(:user_id, :name, :website, :address_1, :address_2, :city, :state, :zip, :country, :fax_number, :phone_number, :longitude, :latitude, :status)
  end
end
