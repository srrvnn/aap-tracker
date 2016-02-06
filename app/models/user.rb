class User < ActiveRecord::Base

  acts_as_voter

  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user.nil?
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.official = true
      user.volunteer = true
      user.save!
    end
  end

end