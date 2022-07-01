Rails.application.routes.draw do
  get '/facebook-webhooks', to: 'facebook_webhooks#verify'
  post '/facebook-webhooks', to: 'facebook_webhooks#handle'
end
