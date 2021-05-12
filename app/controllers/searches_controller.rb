class SearchesController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery :except => [:surgeon_finder, :map_the_surgeons, :track_the_clicks]

  def create
  end

  #search surgeon
  def surgeon_locator
    @search = Search.new
    render layout: "user_layout.html.erb"
  end

  #find the surgeons
  def map_the_surgeons
    Geokit::Geocoders::GoogleGeocoder.api_key = Rails.application.secrets.google_maps_api_key
    result = Geokit::Geocoders::GoogleGeocoder.geocode(params[:zip])
    @latitude_of_zip_code = result.lat
    @longitude_of_zip_code = result.lng
    if (@latitude_of_zip_code != nil && @longitude_of_zip_code != nil)
      search_type = Search.get_search_type(params[:procedure_types], params[:area_of_discomfort])

      center_point = [@latitude_of_zip_code, @longitude_of_zip_code]
      @locations = Location.near(center_point, params[:search_radius])
      if @locations && @locations.length > 0
        @location_ids = @locations.pluck(:id).to_s.gsub!(/[\[\]]/, "") rescue []
        @surgeon_locations = Surgeon.joins(:location).where("surgeons.status = 'publish' and surgeons.location_id IN (#{@location_ids}) AND surgeons.procedure_types_array && ?", search_type).select("locations.*, surgeons.*, locations.id, surgeons.id as surgeon_id").group("locations.id, surgeons.id")
        @search = Search.create!(search_radius: params[:search_radius], procedure_types: params[:procedure_types], zip: params[:zip], area_of_discomfort: params[:area_of_discomfort], procedure_type: search_type, latitude: @latitude_of_zip_code, longitude: @longitude_of_zip_code)

        if @surgeon_locations
          @surgeon_ids = @surgeon_locations.pluck("surgeons.id")
          @surgeon_ids.each do |surgeon_id|
            SearchResult.create!(search_id: @search.id, surgeon_id: surgeon_id)
          end
        end
        render json: { locations: @surgeon_locations, latitude: @latitude_of_zip_code, search_id: @search.id, longitude: @longitude_of_zip_code }, status: :ok
      elsif render json: { errors: "Locations not found.", latitude: @latitude_of_zip_code, longitude: @longitude_of_zip_code }, status: :ok
      end
    else
      render json: { errors: "Locations not found. The zip code entered is wrong." }, status: :ok
    end
  end

  #track the website clicks
  def track_the_clicks
    Link.create!(surgeon_id: params[:surgeon_id], search_id: params[:search_id], link_type: "website")
    if params[:url] =~ URI::regexp
      redirect_to params[:url]
    elsif "http://#{params[:url]}" =~ URI::regexp
      redirect_to "http://#{params[:url]}"
    end
  end

  #locator as an embeddable widget - for external sites
  def surgeon_finder
    @search = Search.new
  end

  #track the clicks on phone number
  def track_the_phone
    Link.create!(surgeon_id: params[:surgeon_id], search_id: params[:search_id], link_type: "phone")
    render json: {}, status: :ok
  end
end
