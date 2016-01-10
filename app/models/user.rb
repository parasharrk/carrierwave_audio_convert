class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  mount_uploader :audio, AudioUploader
end
