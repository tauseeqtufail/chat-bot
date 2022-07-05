
module FacebookMessanger
  class UserName < FacebookMessanger::Base
    def call
      profile.dig('first_name')
    end

    private

    def profile
      HTTParty.get("https://graph.facebook.com/#{sender_psid}?fields=first_name,last_name&access_token=#{Rails.application.credentials.facebook[:page_access_token]}")
    end
  end
end
