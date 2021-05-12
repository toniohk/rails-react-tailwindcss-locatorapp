namespace :surgeons do
  desc "Import the locations and its surgeons from the csv"
  task :update_data => :environment do
  	puts "rake started"
    
    Search.all.each do |s|
    	s.procedure_type = [Search.get_search_type(s.procedure_types, s.area_of_discomfort)]
    	s.save(validate: false)
    end
    puts "rake finished"
  end

end