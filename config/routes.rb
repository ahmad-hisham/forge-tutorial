Rails.application.routes.draw do

  get '/forge/hubs/', to: 'forge_data_hub#index', as: 'forge_data_hubs'

  get '/forge/hubs/:id', to: 'forge_data_hub#show', as: 'forge_data_hub_show', constraints: { id: /.*/ } # maybe /([^\/]+?)(?=\.json|\.html|$|\/)/

  get 'forge_auth/callback'

  get 'forge_auth/login'

  get 'upload_sample/run'
  
  get 'welcome/index'

  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
