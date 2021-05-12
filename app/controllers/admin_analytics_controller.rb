class AdminAnalyticsController < ApplicationController
  skip_before_action :authenticate_user!, :except => [:index, :search_results]

  def index
    if params[:search]
      @searches = Search.order("id DESC").search(params[:search]).paginate(page: params[:page], per_page: 30)
    else
      @searches = Search.group(:zip).count.sort_by { |k, v| v }.reverse
    end
  end

  def search_results
    @search = Search.find(params[:id])
    @search_results = SearchResult.where(search_id: params[:id]).paginate(page: params[:page], per_page: 30)
  end

  # Admin generates report for each dr
  def generate_report
    Geokit::Geocoders::GoogleGeocoder.api_key = Rails.application.secrets.google_maps_api_key
    @surgeon = Surgeon.find(params[:surgeon_id])
    location = Location.find(@surgeon.location_id)
    search50 = Search.near([location.latitude, location.longitude], 50, order: :id)
    search25 = Search.near([location.latitude, location.longitude], 25, order: :id)
    search50_ids = search50.pluck(:id).to_s.gsub!(/[\[\]]/, "") rescue []
    search25_ids = search25.pluck(:id).to_s.gsub!(/[\[\]]/, "") rescue []
    @results_50 = Search.where("id = ANY (?) AND id <> ALL (?)", "{#{search50_ids}}", "{#{search25_ids}}").group(:zip).limit(10).count(:zip)
    @results_25 = Search.where("id = ANY (?)", "{#{search25_ids}}").group(:zip).limit(10).count(:zip)
    # @results_25 = SearchResult.joins(:search).where("searches.search_radius = 25 and search_results.surgeon_id = #{params[:surgeon_id]}").group(:zip).limit(10).count(:surgeon_id)

    # @results_50 = SearchResult.joins(:search).where("searches.search_radius = 50 and search_results.surgeon_id = #{params[:surgeon_id]}").group(:zip).limit(10).count(:surgeon_id)

    @procedure_types = @surgeon.procedure_types_array if @surgeon.procedure_types_array
    @total_surgeons = Surgeon.all.count

    @surgeons_cervical_fusion = Surgeon.where("'Cervical Fusion' = ANY (surgeons.procedure_types_array)").count
    @surgeons_cervical_motion = Surgeon.where("'Cervical Motion' = ANY (surgeons.procedure_types_array)").count
    @surgeons_lumbar_motion = Surgeon.where("'Lumbar Motion' = ANY (surgeons.procedure_types_array)").count
    @surgeons_lumbar_fusion = Surgeon.where("'Lumbar Fusion' = ANY (surgeons.procedure_types_array)").count
    @surgeons_cc_cervical = Surgeon.where("'Comprehensive Care Cervical' = ANY (surgeons.procedure_types_array)").count
    @surgeons_cc_lumbar = Surgeon.where("'Comprehensive Care Lumbar' = ANY (surgeons.procedure_types_array)").count

    # @total_search_count = Search.where("id = ANY (?)", "{#{search50_ids}}").count
    @cervical_fusion_count = Search.where("id = ANY (?) AND 'Cervical Fusion' = ANY (procedure_type)", "{#{search50_ids}}").count
    @cervical_motion_count = Search.where("id = ANY (?) AND 'Cervical Motion' = ANY (procedure_type)", "{#{search50_ids}}").count
    @lumbar_motion_count = Search.where("id = ANY (?) AND 'Lumbar Motion' = ANY (procedure_type)", "{#{search50_ids}}").count
    @lumbar_fusion_count = Search.where("id = ANY (?) AND 'Lumbar Fusion' = ANY (procedure_type)", "{#{search50_ids}}").count
    @cc_fusion_count = Search.where("id = ANY (?) AND 'Comprehensive Care Cervical' = ANY (procedure_type)", "{#{search50_ids}}").count
    @cc_motion_count = Search.where("id = ANY (?) AND 'Comprehensive Care Lumbar' = ANY (procedure_type)", "{#{search50_ids}}").count

    @total_search_count = @cervical_fusion_count + @cervical_motion_count + @lumbar_motion_count + @lumbar_fusion_count + @cc_fusion_count +  @cc_motion_count

    @total_clicks = @surgeon.links.where(link_type: "website").count
    @phone_calls = @surgeon.links.where(link_type: "phone").count

    #grover
    respond_to do |format|
      format.html
      format.pdf do
        grover = Grover.new(root_url + "generate_report?surgeon_id=#{params[:surgeon_id]}", format: "A4", timeout: 0)
        pdf = grover.to_pdf
        File.open("dr_report.pdf", "wb+", encoding: "ascii-8bit") do |f|
          f.write(pdf)
        end
        send_data File.open("dr_report.pdf", "rb").read, type: "application/pdf", filename: "Report for Dr. #{@surgeon.full_name}.pdf" #, disposition: "inline"
      end
    end
  end

  #To show heat map
  def show_heat_map
    Geokit::Geocoders::GoogleGeocoder.api_key = Rails.application.secrets.google_maps_api_key
    if params[:surgeon_id] && params[:surgeon_id] != ""
      surgeon = Surgeon.find(params[:surgeon_id])
      location = Location.find(surgeon.location_id)
      search50 = Search.near([location.latitude, location.longitude], 50, order: :id)
      search50_ids = search50.pluck(:id).to_s.gsub!(/[\[\]]/, "") rescue []
      results_50 = Search.where("id = ANY (?)", "{#{search50_ids}}").select("latitude, longitude")
      center = { "latitude" => location.latitude, "longitude" => location.longitude }
    else
      #for the client specific reports
      results_50 = Search.select("latitude, longitude")
      center = { "latitude" => "37.00", "longitude" => "-118.00" }
    end
    if results_50
      render json: { locations: results_50, center: center }, status: :ok
    else
      render json: { errors: "Locations not found." }, status: :unprocessable_entity
    end
  end

  # Client specific reports
  def client_reports
    @zip_codes = Search.all.group(:zip).select("count(zip) as count_zip, zip as searched_zip").limit(10)
    @searched_surgeons = Link.joins(surgeon: :location).group("links.surgeon_id, locations.phone_number, locations.zip, surgeons.url, surgeons.full_name").select("count(surgeon_id), surgeon_id, surgeons.full_name, locations.phone_number, locations.zip, surgeons.url").order("count DESC").limit(5)

    @total_surgeons = Surgeon.all.count

    @surgeons_cervical_fusion = Surgeon.where("'Cervical Fusion' = ANY (surgeons.procedure_types_array)").count
    @surgeons_cervical_motion = Surgeon.where("'Cervical Motion' = ANY (surgeons.procedure_types_array)").count
    @surgeons_lumbar_motion = Surgeon.where("'Lumbar Motion' = ANY (surgeons.procedure_types_array)").count
    @surgeons_lumbar_fusion = Surgeon.where("'Lumbar Fusion' = ANY (surgeons.procedure_types_array)").count
    @surgeons_cc_cervical = Surgeon.where("'Comprehensive Care Cervical' = ANY (surgeons.procedure_types_array)").count
    @surgeons_cc_lumbar = Surgeon.where("'Comprehensive Care Lumbar' = ANY (surgeons.procedure_types_array)").count

    # @total_search_count = Search.count
    @cervical_fusion_count = Search.where("'Cervical Fusion' = ANY (procedure_type)").count
    @cervical_motion_count = Search.where("'Cervical Motion' = ANY (procedure_type)").count
    @lumbar_motion_count = Search.where("'Lumbar Motion' = ANY (procedure_type)").count
    @lumbar_fusion_count = Search.where("'Lumbar Fusion' = ANY (procedure_type)").count
    @cc_fusion_count = Search.where("'Comprehensive Care Cervical' = ANY (procedure_type)").count
    @cc_motion_count = Search.where("'Comprehensive Care Lumbar' = ANY (procedure_type)").count
    @total_search_count =  @cervical_fusion_count + @cervical_motion_count + @lumbar_motion_count + @lumbar_fusion_count + @cc_fusion_count + @cc_motion_count

    logger.info "total_surgeons---#{@total_surgeons.size}---#{@surgeons_cervical_fusion.size}"

    #grover
    respond_to do |format|
      format.html
      format.pdf do
        grover = Grover.new(root_url + "client_reports", format: "A4", timeout: 0, cache: false)
        pdf = grover.to_pdf
        File.open("client_report.pdf", "wb+", encoding: "ascii-8bit") do |f|
          f.write(pdf)
        end
        #File.open(Rails.root.join('client_report.pdf'),'wb', 0644, encoding: 'utf-8') { |f| f.write(pdf)}
        send_data File.open("client_report.pdf", "rb").read, type: "application/pdf", filename: "Results.pdf" #, disposition: "inline"
      end
    end
  end

  #To export db
  def export_db
    @users = User.all
    @locations = Location.all
    @surgeons = Surgeon.all
    @searches = Search.all
    @search_results = SearchResult.all
    @links = Link.all

    respond_to do |format|
      format.html
      format.xlsx do
        response.headers[
          "Content-Disposition"
        ] = "attachment; filename=Locatorapp_development.xlsx"
      end
    end
  end

  #Dashboard - if admin logged in - show dashboard
  def dashboard
    if user_signed_in? && current_user.manager? #managers should see surgeons in their location
      redirect_to surgeons_path(:user_id => current_user.id)
    elsif !user_signed_in? #guest users should see search surgeons
      redirect_to search_surgeons_path
    end
  end

  #list of users
  def users_list
    @users = User.where("deleted_at is NULL").order("id DESC").search(params[:search]).paginate(page: params[:page], per_page: 30)
  end

  def reactive_users
    @users = User.where.not("deleted_at is NULL").order("id DESC").search(params[:search]).paginate(page: params[:page], per_page: 30)
  end

  def update_reactive_user
    @user = User.find_by(id: params[:id])
    @user.update(deleted_at: nil)
    redirect_to reactive_users_path
  end

  #activate surgeons
  def activate_surgeons
    @surgeons = Surgeon.where("status = ?", "private").order("id DESC").search(params[:search]).paginate(page: params[:page], per_page: 30)
  end

  #make the surgeon status from private to publish
  def publish_surgeon
    @surgeon = Surgeon.find(params[:id])
    @surgeon.update_column(:status, "publish")
    flash[:notice] = "Surgeon has been successfully made live. You can now verify and edit the surgeon specialities."
    redirect_to edit_surgeon_path(params[:id])
  end

  #activate locations
  def activate_locations
    @locations = Location.where("status = ?", "private").order("id DESC").search(params[:search]).paginate(page: params[:page], per_page: 30)
  end

  #make the location status from private to publish
  def publish_location
    @location = Location.find(params[:id])
    @location.update_column(:status, "publish")
    flash[:notice] = "Location has been successfully made live. You can now verify and edit the location details."
    redirect_to edit_location_path(params[:id])
  end
end
