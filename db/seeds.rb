# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


user = User.create! :email => 'manager@gmail.com', :password => 'password', :password_confirmation => 'password', :role => "manager"
user = User.create! :email => 'admin@gmail.com', :password => 'password', :password_confirmation => 'password', :role => "admin"


@manager = User.find_by_email("manager@gmail.com")
@admin = User.find_by_email("admin@gmail.com")

Location.create! name: "Five Branches University Clinic & Health Center", address_1: "1886 Lundy Ave", city: "San Jose", state: "CA", zip: "95132", country: "USA", user_id: @manager.id , status: 'publish'
Location.create! name: "FIRST HEALTH CLINIC", address_1: "S Capitol Ave #4", city: "San Jose", state: "CA", zip: "95127", country: "USA", user_id: @admin.id , status: 'publish'
Location.create! name: "Valley Health Center Downtown", address_1: "777 E Santa Clara St", city: "San Jose", state: "CA", zip: "95113", country: "USA", user_id: @admin.id , status: 'publish'


@location_1 = Location.find_by_name("Five Branches University Clinic & Health Center");
@location_2 = Location.find_by_name("Valley Health Center Downtown");

Surgeon.create! full_name: "Donny", email: "donny@test.com", url: "http://donny.com", suffix: "MBBS", procedure_types_array: ["Lumbar Fusion", "Cervical Motion"], location_id: @location_1.id, status: 'publish'
Surgeon.create! full_name: "Tim", email: "tim@test.com", url: "http://tim.com", suffix: "MD", procedure_types_array: ["Lumbar Fusion", "Cervical Motion"], location_id: @location_1.id, status: 'publish'
Surgeon.create! full_name: "William", email: "william@test.com", url: "http://william.com", suffix: "DO", procedure_types_array: ["Comprehensive Care Cervical", "Comprehensive Care Lumbar"], location_id: @location_2.id, status: 'publish'
Surgeon.create! full_name: "Chloe", email: "chloe@test.com", url: "http://chloe.com", suffix: "MD", procedure_types_array: ["Comprehensive Care Cervical", "Cervical Motion"], location_id: @location_2.id, status: 'publish'
