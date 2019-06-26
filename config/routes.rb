BlCommons::Engine.routes.draw do
  post '/bl_resources/:resource_name/sync', to: 'resources#sync'
  post '/bl_resources/:resource_name/batch_sync', to: 'resources#batch_sync'
  post '/bl_resources/:resource_name/require_sync', to: 'resources#require_sync'
  get '/bl_resources/:resource_name', to: 'resources#index'
  post '/bl_resources/:resource_name', to: 'resources#create'
  get '/bl_resources/:resource_name/:id', to:  'resources#show'
  put '/bl_resources/:resource_name/:id', to:  'resources#update'
  delete '/bl_resources/:resource_name/:id', to: 'resources#destroy'
end
