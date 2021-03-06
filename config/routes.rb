Rails.application.routes.draw do

  # Forge Model Viewer
  get '/forge/projects/:project_id/items/:item_id/view(/:viewer_id)',     to: 'forge_viewer#view',        as: 'forge_viewer_view', constraints: { project_id: /.*/ , item_id: /.*/ }
  get '/forge/buckets/:bucket_id/objects/:object_name/view(/:viewer_id)', to: 'forge_viewer#view_object', as: 'forge_viewer_view_object', constraints: { bucket_id: /.*/, object_name: /.*/ }

  # Forge Model Derivative
  get '/forge/projects/:project_id/items/:item_id/translate',          to: 'forge_derivative#translate',          as: 'forge_derivative_translate', constraints: { project_id: /.*/ , item_id: /.*/ }
  get '/forge/buckets/:bucket_id/objects/:object_name/translate',      to: 'forge_derivative#translate_object',   as: 'forge_derivative_translate_object', constraints: { bucket_id: /.*/, object_name: /.*/ }

  # Forge Model Derivative - JSON APIs
  get '/forge/projects/:project_id/items/:item_id/translate_start',    to: 'forge_derivative#translate_start',    as: 'forge_derivative_translate_start',    defaults: {format: :json}, constraints: { project_id: /.*/ , item_id: /.*/ }
  get '/forge/projects/:project_id/items/:item_id/translate_progress', to: 'forge_derivative#translate_progress', as: 'forge_derivative_translate_progress', defaults: {format: :json}, constraints: { project_id: /.*/ , item_id: /.*/ }

  # Forge Data Management OSS - Objects
  get '/forge/buckets/:bucket_id/objects',              to: 'forge_data_object#index',  as: 'forge_data_objects', constraints: { bucket_id: /.*/ }
  get '/forge/buckets/:bucket_id/objects/:object_name', to: 'forge_data_object#show',   as: 'forge_data_object_show', constraints: { bucket_id: /.*/, object_name: /.*/ }
  get '/forge/buckets/:bucket_id/upload',               to: 'forge_data_object#upload', as: 'forge_data_object_upload', constraints: { bucket_id: /.*/ }

  # Forge Data Management OSS - Buckets
  get  '/forge/buckets/',    to: 'forge_data_bucket#index', as: 'forge_data_buckets'
  get  '/forge/buckets/:id', to: 'forge_data_bucket#show',  as: 'forge_data_bucket_show', constraints: { id: /.*/ }
  post '/forge/buckets/new', to: 'forge_data_bucket#new',   as: 'forge_data_bucket_new'

  # Forge Data Management - Folder Actions
  post '/forge/projects/:project_id/folders/:folder_id/upload',   to: 'forge_data_item#upload',     as: 'forge_data_item_upload', constraints: {project_id: /.*/ , folder_id: /.*/ }
  post '/forge/projects/:project_id/folders/:folder_id/new',      to: 'forge_data_item#new_folder', as: 'forge_data_item_new', constraints: {project_id: /.*/ , folder_id: /.*/ }

  # Forge Data Management - Folders and Items
  get '/forge/projects/:project_id/folders/:folder_id/contents', to: 'forge_data_item#index',       as: 'forge_data_items', constraints: {project_id: /.*/ , folder_id: /.*/ }
  get '/forge/projects/:project_id/folders/:folder_id',          to: 'forge_data_item#show_folder', as: 'forge_data_folder_show', constraints: {project_id: /.*/ , folder_id: /.*/ }
  get '/forge/projects/:project_id/items/:item_id',              to: 'forge_data_item#show_item',   as: 'forge_data_item_show', constraints: { project_id: /.*/ , item_id: /.*/ }

  # Forge Data Management - Projects
  get '/forge/hubs/:hub_id/projects/',    to: 'forge_data_project#index', as: 'forge_data_projects', constraints: { hub_id: /.*/ }
  get '/forge/hubs/:hub_id/projects/:id', to: 'forge_data_project#show',  as: 'forge_data_project_show', constraints: { id: /.*/ , hub_id: /.*/}

  # Forge Data Management - Hubs
  get '/forge/hubs/',    to: 'forge_data_hub#index', as: 'forge_data_hubs'
  get '/forge/hubs/:id', to: 'forge_data_hub#show',  as: 'forge_data_hub_show', constraints: { id: /.*/ } # maybe /([^\/]+?)(?=\.json|\.html|$|\/)/

  # Forge OAuth
  get '/forge/login',          to: 'forge_auth#login',     as: 'forge_login'
  get '/forge/login/callback', to: 'forge_auth#callback',  as: 'forge_login_callback'
  get '/forge/login_app',      to: 'forge_auth#login_app', as: 'forge_login_app'

  # Upload DWG for Viewer Samples
  get 'viewer_sample',    to: 'viewer_sample#index', as: 'viewer_sample'
  get 'viewer_sample/run'

  # Simple Upload Sample
  get 'upload_sample/run'

  # Welcome landing page
  get 'welcome/index'
  root 'welcome#index'

end
