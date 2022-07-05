class FacebookWebhooksController < ApplicationController

  # Verify webhook and subscribe services
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
    FacebookMessanger::Response.call(message)
    head :ok
  end

  private

  def message
    params['entry'][0]['messaging'][0]
  end
end
