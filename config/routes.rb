Rails.application.routes.draw do

  #this routes is for conversations
  resources :rooms, except: [:create] do
    member do
      #this is join another users in the rooms
      post 'join'
      #Post /rooms/:id/join      
      #this is leave the room
      delete 'leave'
      #Delete /rooms/:id/leave

      resources :messages
      #/rooms/:id/messages
    end
  end

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'



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
      #GET users/:id/followers
      get 'following'
      #GET users/:id/following



    end
    
  end
  resources :categories

  resources :activities do
  #/activities 
  	member do
  	#/activities/:id


      post 'join'
      #POST /activities/:id/join
      
      
      
      #for likes
  		post 'like'
  		#POST /activities/:id/like
  		post 'unlike'

      #POST /activities/:id/unlike
      post 'share'

  		#POST /activities/:id/unlike

      #post 'voteup/:votable_user_id' => 'activities#voteup'
      post 'voteup'
      #POST users/:id/voteup/
      post 'votedown'
      #post 'votedown/:votable_user_id' => 'activities#votedown'
      #POST users/:id/votedown
  	end

    resources :comments, shallow: true
    #this basically routes the collection actions #index, #create under
    #get or post /activities/:id/comments
    #but leaves the member routes aka #get, #update, #delete to the /comments/:id routes
    #the comments have a commentable_id that is basically a per-model index, not sure how it would work
  end




  end	
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'registrations',
  }
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
