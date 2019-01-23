class RegistrationsController < DeviseTokenAuth::RegistrationsController


protected

	def render_update_success
    render json: UserSerializer.new(@resource).serialized_json
  	end


end
