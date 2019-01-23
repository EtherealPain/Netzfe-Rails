Rails.application.routes.draw do
  resources :users , only: :show do 
    member do
      post 'archive'
      #/users/:id/archive
      post 'follow'
      #/users/:id/follow
      post 'block'
      #/users/:id/block
      post 'unfollow'
      #/users/:id/unfollow
      post 'unblock'
      #/users/:id/unblock
      # post/:id/force_to_unfollow
       #/users/:id/force_to_unfollow
      get 'followers'
      #get users/:id/followers
      get 'following'
      #get users/:id/following



    end
    
  end
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
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'registrations',
  }
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
