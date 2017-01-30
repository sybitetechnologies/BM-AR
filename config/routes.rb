require 'api_constraints'
Rails.application.routes.draw do
  
  namespace :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      mount_devise_token_auth_for 'User', at: 'auth'
    	resources :transactions, only: [:index]
    	get 'balance' => 'transactions#balance'
    	post 'deposit' => 'transactions#deposit'
    	post 'withdraw' => 'transactions#withdraw'
    	post 'transfer' => 'transactions#transfer'
    end
  end

  get 'main' => 'main#index'
  get 'home' => 'main#home'
  root :to => "main#home"
end
