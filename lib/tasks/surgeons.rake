namespace :surgeons do
  desc "Import the locations and its surgeons from the csv"
  task :import => :environment do
    @admin = User.find_by_email("admin@gmail.com")  

    csv_text = File.read(Rails.root.join("lib", "csvs", "surgeons.csv"))
    csv = CSV.parse(csv_text.scrub, :headers => true)
    csv.each do |row|
      
      @existing_loc = Location.where("address_1 = ? and address_2 = ? and zip = ? and city = ? and state= ? and country = ?", "#{row['address']}", "#{row['address2']}", "#{row['zip']}", "#{row['city']}", "#{row['state']}", "#{row['country']}").first
      unless @existing_loc #no location exists
        @location = Location.new
        @location.name = row["locationname"]
        @location.address_1 = row["address"]
        @location.address_2 = row["address2"]
        @location.city = row["city"]
        @location.zip = row["zip"]
        @location.state = row["state"]
        @location.country = row["country"]
        @location.phone_number = row["phone"]
        @location.fax_number = row["fax"]
        @location.latitude = row["lat"]
        @location.longitude = row["lng"]
        @location.status = row["status"]
        @location.user_id = @admin.id
        @location.created_at = row["date"]
        @location.updated_at = row["date"]
        @location.save(:validate => false)
        puts "#{@location.address_1}, #{@location.zip} saved"
      else #location exists
        puts "This location - #{@existing_loc.address_1}, #{@existing_loc.zip} already exists"
        @location = @existing_loc
      end
      
      @procedure_types = []
  #   ['Comprehensive Care Cervical', 'Comprehensive Care Lumbar', 'Cervical Fusion', 'Lumbar Fusion', 'Cervical Motion', 'Lumbar Motion']
      if row["proceduretype_compcare_cervical"] == '1'
        @procedure_types << "Comprehensive Care Cervical"
      end
      
      if row["proceduretype_compcare_lumbar"] == '1' 
        @procedure_types << "Comprehensive Care Lumbar"
      end
      if row["proceduretype_fusion_cervical"] == '1' 
        @procedure_types << "Cervical Fusion"
      end
      if row["proceduretype_fusion_lumbar"] == '1' 
        @procedure_types << "Lumbar Fusion"
      end
      if row["proceduretype_motion_cervical"] == '1' 
        @procedure_types << "Cervical Motion"
      end
      if row["proceduretype_motion_lumbar"] == '1' 
        @procedure_types << "Lumbar Motion"
      end

      @surgeon = Surgeon.new
      
      @surgeon.full_name = row["name"]
      @surgeon.email = row["email"]
      @surgeon.url = row["url"]
      @surgeon.suffix = row["doctor_suffix"]
      @surgeon.procedure_types_array = @procedure_types
      @surgeon.status = row["status"]
      @surgeon.location_id = @location.id
      @surgeon.created_at = row["date"]
      @surgeon.updated_at = row["date"]
      
      @surgeon.save(:validate => false) 
      puts "#{@surgeon.full_name}, #{@surgeon.email} saved"
    end
    
  end

end