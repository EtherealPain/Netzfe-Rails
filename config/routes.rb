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
      post 'share'
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
