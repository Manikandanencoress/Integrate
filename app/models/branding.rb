class Branding < ActiveRecord::Base
  has_attached_file :logo,
                    :storage => Sumuru::Application.config.paperclip_storage_type,
                    :s3_credentials => "#{Rails.root}/config/s3.yml"
  
  belongs_to(:studio)
end