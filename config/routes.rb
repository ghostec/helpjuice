Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "searches#search"
  put '/searches/increment', to: 'searches#increment'
  put '/searches/decrement', to: 'searches#decrement'
  get '/searchers/clean', to: 'searches#clean'
end
