Rails.application.routes.draw do

  get 'forge_auth/callback'

  get 'forge_auth/login'

  get 'upload_sample/run'
  
  get 'welcome/index'

  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
