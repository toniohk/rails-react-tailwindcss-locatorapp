Rails.application.routes.draw do
   devise_for :users, skip: [:registrations]
   as :user do
      get "/sign_in" => "devise/sessions#new" # custom path to login/sign_in
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      put 'users' => 'devise/registrations#update', :as => 'user_registration'
      get 'dashboard' => 'devise/sessions#new'
  end
  resources :users, only: [:edit, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :surgeons
  resources :locations do
    resources :surgeons
  end
  resources :searches
  resources :admin_analytics
  # root 'surgeons#index'

  # routes to set location/surgeon to "live/public"
  get 'set_surgeon_status', to: 'surgeons#set_status'
  get 'set_location_status', to: 'locations#set_status'
  # root page
  root 'admin_analytics#dashboard'

  # surgeon locator page - internal
  get 'search_surgeons', to: 'searches#surgeon_locator'
  #display the surgeons when details are submitted in surgeon locator page
  post '/map_the_surgeons',  to: 'searches#map_the_surgeons'

  #track the website click in surgeon locator page
  get '/track_the_clicks', to: 'searches#track_the_clicks'

  #export db as .xls for admin
  get '/export_db', to: 'admin_analytics#export_db'

  #admin analytics - search results
  get '/search_results', to: 'admin_analytics#search_results'
  #admin analytics - download pdf report for surgeon
  get 'generate_report', to: 'admin_analytics#generate_report'
  #admin analytics - show heat map in pdfs
  get '/show_heat_map', to: 'admin_analytics#show_heat_map'
  #admin analytics - download client reports
  get '/client_reports', to: 'admin_analytics#client_reports'

  #list of all users - admin/location manager
  get '/users', to: 'admin_analytics#users_list'
  get '/reactive_users', to: 'admin_analytics#reactive_users'
  get 'update_reactive_user/:id', controller: 'admin_analytics', action: :update_reactive_user, as: :update_reactive_user

  #track the phone number clicks in surgeon locator page
   post '/track_the_phone', to: 'searches#track_the_phone'

  #external - surgeon locator
  get 'surgeon_finder', to: 'searches#surgeon_finder'
  get 'dashboard', to: 'admin_analytics#dashboard'

  #activate surgeons/locations
  get 'activate_surgeons', to: 'admin_analytics#activate_surgeons'
  get 'publish_surgeon', to: 'admin_analytics#publish_surgeon'
  get 'activate_locations', to: 'admin_analytics#activate_locations'
  get 'publish_location', to: 'admin_analytics#publish_location'
end
