class ShortUserSerializer < ActiveModel::Serializer
  type :user
  attributes :id, :first_name, :last_name, :avatar

  def avatar
  	Rails.application.routes.url_helpers.rails_blob_path(object.avatar, only_path: true) if object.avatar.attachment
  end
end
