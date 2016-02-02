OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets.fb_app_id, Rails.application.secrets.fb_app_secret,
  		:scope => 'email, user_friends, user_managed_groups', :image_size => 'normal'
end