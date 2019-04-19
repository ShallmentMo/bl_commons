BlCommons::Engine.routes.draw do
  post '/bl_resources/:resource_name/sync', to: 'resources#sync'
  get '/bl_resources/:resource_name', to: 'resources#index'
  post '/bl_resources/:resource_name', to: 'resources#create'
  get '/bl_resources/:resource_name/:id', to:  'resources#show'
  put '/bl_resources/:resource_name/:id', to:  'resources#update'
  delete '/bl_resources/:resource_name/:id', to: 'resources#destroy'
end
