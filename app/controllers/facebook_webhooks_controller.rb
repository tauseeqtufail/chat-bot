class FacebookWebhooksController < ApplicationController
  def verify
    mode = params['hub.mode']
    token = params['hub.verify_token']
    challenge = params['hub.challenge']

    if mode && token
      if mode === 'subscribe' && token === Rails.application.credentials.facebook[:webhook_verify_token]
        render plain: challenge
      else
        head :forbidden
      end
    end
  end

  def handle
    request_body = {
      "recipient": {
        "id": sender_psid
      },
      "message": {
        "text": "Welcome, #{sender_name}"
      }
    }

    send_message(request_body)

    head :ok
  end

  def sender_psid
    params['entry'][0]['messaging'][0]['sender']['id']
  end

  def sender_name
    response = HTTParty.get("https://graph.facebook.com/#{sender_psid}?fields=first_name,last_name&access_token=#{Rails.application.credentials.facebook[:page_access_token]}")
    response.dig('first_name')
  end

  def send_message(request_body)
    HTTParty.post(
      'https://graph.facebook.com/v2.6/me/messages',
      query: { access_token: Rails.application.credentials.facebook[:page_access_token] },
      body: request_body
    )
  end
end
