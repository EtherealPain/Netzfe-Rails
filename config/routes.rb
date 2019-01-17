Rails.application.routes.draw do
  resources :categories
  resources :activities do
  #/activities 
  	member do
  	#/activities/:id


      #for likes
  		post 'like'
  		#POST /activities/:id/like
  		post 'unlike'
  		#POST /activities/:id/unlike

  	end
    resources :comments, shallow: true
    #this basically routes the collection actions #index, #create under
    #get or post /activities/:id/comments
    #but leaves the member routes aka #get, #update, #delete to the /comments/:id routes
    #the comments have a commentable_id that is basically a per-model index, not sure how it would work



  end	
  mount_devise_token_auth_for 'User', at: 'auth'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
