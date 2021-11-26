Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "receptions"      => "receptions#index"
  post "receptions"      => "receptions#create"
  delete "receptions/:id" => "receptions#delete"

end
