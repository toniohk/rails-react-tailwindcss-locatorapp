class Location < ApplicationRecord
  belongs_to :user
  has_many :surgeons, dependent: :destroy
  validates_presence_of :address_1, :city, :state, :country
  #  validates_presence_of :name, :address_1, :address_2, :city, :state, :zip, :country, :fax_number, :phone_number

  STATUS = %w[private publish]
  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? and (obj.address_1_changed? || obj.city_changed? || obj.state_changed? || obj.country_changed?) }

  def address
    [address_1, city, state, country].compact.join(", ")
  end

  def self.search(search)
    locations = all # for not existing search params
    locations = locations.where("LOWER(name) like LOWER('%#{search}%') OR LOWER(website) like LOWER('%#{search}%') OR LOWER(address_1) like LOWER('%#{search}%') OR LOWER(address_2) like LOWER('%#{search}%') OR LOWER(city) like LOWER('%#{search}%') OR LOWER(state) like LOWER('%#{search}%') OR zip like '%#{search}%' OR phone_number like '%#{search}%' OR fax_number like '%#{search}%'") if search
    locations
  end
end
