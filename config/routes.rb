Rails.application.routes.draw do
  resources :categories
  resources :activities do
  #/activity 
  	member do
  	#/activity/:id

  		post 'like'
  		#POST /activities/:id/like
  		post 'unlike'
  		#POST /activities/:id/unlike
  	end
  end	
  mount_devise_token_auth_for 'User', at: 'auth'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
