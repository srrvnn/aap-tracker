Recaptcha.configure do |config|
  config.public_key  = '6LdM6BYTAAAAABeumb-FeBmpr_VxdAeK1Cn_rh8C'
  config.private_key = Rails.application.secrets.recaptcha_key
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end