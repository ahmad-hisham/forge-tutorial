Rails.application.routes.draw do

  post '/forge/projects/:project_id/folders/:folder_id/upload',  to: 'forge_data_item#upload',      as: 'forge_data_item_upload', constraints: {project_id: /.*/ , folder_id: /.*/ }

  get '/forge/projects/:project_id/folders/:folder_id/contents', to: 'forge_data_item#index',       as: 'forge_data_items', constraints: {project_id: /.*/ , folder_id: /.*/ }
  get '/forge/projects/:project_id/folders/:folder_id',          to: 'forge_data_item#show_folder', as: 'forge_data_folder_show', constraints: {project_id: /.*/ , folder_id: /.*/ }
  get '/forge/projects/:project_id/items/:item_id',              to: 'forge_data_item#show_item',   as: 'forge_data_item_show', constraints: { project_id: /.*/ , item_id: /.*/ }

  get '/forge/hubs/:hub_id/projects/', to: 'forge_data_project#index', as: 'forge_data_projects', constraints: { hub_id: /.*/ }
  get '/forge/hubs/:hub_id/projects/:id', to: 'forge_data_project#show', as: 'forge_data_project_show', constraints: { id: /.*/ , hub_id: /.*/}

  get '/forge/hubs/', to: 'forge_data_hub#index', as: 'forge_data_hubs'
  get '/forge/hubs/:id', to: 'forge_data_hub#show', as: 'forge_data_hub_show', constraints: { id: /.*/ } # maybe /([^\/]+?)(?=\.json|\.html|$|\/)/

  get '/forge/login/',         to: 'forge_auth#login',    as: 'forge_login'
  get '/forge/login/callback', to: 'forge_auth#callback', as: 'forge_login_callback'

  get 'upload_sample/run'
  
  get 'welcome/index'

  root 'welcome#index'

end
