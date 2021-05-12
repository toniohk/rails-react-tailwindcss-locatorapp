class Surgeon < ApplicationRecord
  belongs_to :location
  has_many :search_results, dependent: :destroy
  has_many :links, dependent: :destroy

  #serialize :proc_types
  
  validates_presence_of :full_name
  STATUS = %w[private publish]
  
  before_save do 
    self.procedure_types_array.reject! { |c| c.to_s == "0" }
  end
  
  def self.search(search)
    surgeons = all # for not existing search params
    surgeons = surgeons.where("LOWER(full_name) like LOWER('%#{search}%') OR LOWER(email) like LOWER('%#{search}%') OR LOWER(url) like LOWER('%#{search}%')") if search
    surgeons
  end
  
  def self.search_by_location(search, location_id)
    surgeons = all.where("location_id = ?", location_id) #surgeons for a particular location
    surgeons = surgeons.where("location_id = #{location_id} AND (LOWER(full_name) like LOWER('%#{search}%') OR LOWER(email) like LOWER('%#{search}%') OR LOWER(url) like LOWER('%#{search}%')) ") if search #surgeons for a particular location when searched for
    surgeons
  end

end
