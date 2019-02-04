class RegistrationsController < DeviseTokenAuth::RegistrationsController

	protected
		def render_update_success
			render json: @resource
		end
end
