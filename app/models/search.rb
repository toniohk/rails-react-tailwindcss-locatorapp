class Search < ApplicationRecord
  has_many :search_results
  has_many :links
  geocoded_by :coordination
  after_validation :geocode

  def self.search(search)
    searches = all # for not existing search params
    searches = searches.where("'#{search}' = procedure_types OR zip like '%#{search}%' OR Cast(search_radius As varchar)='#{search}' ") if search
    searches
  end

  def coordination
    "#{latitude}, #{longitude}"
  end

  def self.get_search_type(procedure_types, area_of_discomfort)
    search_type = ""
    puts "================ #{procedure_types}  ====================== #{area_of_discomfort} =============="
    if procedure_types == "Comprehensive Care" && area_of_discomfort == "Lumbar"
      search_type = '{"Comprehensive Care Lumbar"}'
    elsif procedure_types == "Comprehensive Care" && area_of_discomfort == "Cervical"
      search_type = '{"Comprehensive Care Cervical"}'
    elsif procedure_types == "Fusion" && area_of_discomfort == "Lumbar"
      search_type = '{"Lumbar Fusion"}'
    elsif procedure_types == "Fusion" && area_of_discomfort == "Cervical"
      search_type = '{"Cervical Fusion"}'
    elsif procedure_types == "Motion" && area_of_discomfort == "Lumbar"
      search_type = '{"Lumbar Motion"}'
    elsif procedure_types == "Motion" && area_of_discomfort == "Cervical"
      search_type = '{"Cervical Motion"}'
    end
    return search_type
  end
end
