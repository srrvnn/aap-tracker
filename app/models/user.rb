class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    _permissions = self.groups_from_graphAPI(auth.credentials)

    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user.nil?
      user.official = _permissions['official']
      user.volunteer = _permissions['volunteer']
      user.save!
    end

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.official = _permissions['official']
      user.volunteer = _permissions['volunteer']
      user.save!
    end

  end

  def self.groups_from_graphAPI(auth)
      access_token = auth['token']
      facebook = Koala::Facebook::API.new(access_token)
      _groups = facebook.get_connections("me", "groups")

      _permissions = Hash.new
      _permissions['official'] = _groups.any?{|a| a["id"] == Rails.application.secrets.fb_officials_group_id.to_s }
      _permissions['volunteer'] = _groups.any?{|a| a["id"] == Rails.application.secrets.fb_volunters_group_id.to_s }
      return _permissions
    end
end