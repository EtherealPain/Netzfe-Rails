class SessionsController < DeviseTokenAuth::SessionsController
    after_action :after_login, only: :create
    
    def after_login
        if current_user.archived
            head(:forbidden)
        end
    end
end
