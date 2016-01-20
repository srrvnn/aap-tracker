OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '443909469137182', 'da0349aeb8f881810a04e3d9569a166d',
  		:scope => 'email, user_friends', :image_size => 'normal'
end