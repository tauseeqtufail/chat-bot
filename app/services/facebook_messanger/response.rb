
module FacebookMessanger
  class Response < FacebookMessanger::Base

    def call
      if data[:message].present?
        if Rails.cache.read(sender_psid)
          begin
            results = CoinGecko::Search.call(seach_params)
            @message << FacebookMessanger::MessageBuilder.quick_reply(results)
            Rails.cache.delete(sender_psid)
          rescue
            @message << FacebookMessanger::MessageBuilder.text('Coin not found')
          end
        elsif data[:message][:quick_reply].present?
          result = CoinGecko::HistoricalPrice.call(selected_coins_params)
          build_message = ""
          result.each do |history|
            build_message +="Date: #{history[:date]} \n Price: #{history[:price]} \n\n"
          end
          @message << FacebookMessanger::MessageBuilder.text(build_message)
        elsif data[:message][:text]
          buttons = [{ title: 'ID', payload: 'COIN_BY_ID' }, { title: 'NAME', payload: 'COIN_BY_NAME' }]
          text = "Search coins by?"
          name = FacebookMessanger::UserName.call(data)
          @message.push(FacebookMessanger::MessageBuilder.text("Welcome, #{name}"))
          @message.push(FacebookMessanger::MessageBuilder.button_template(buttons, text))
        end
      elsif data[:postback].present?
        Rails.cache.write(sender_psid, data[:postback][:payload])
      end

      respond_to_messager if @message.compact.present?
    end

    private

    def seach_params
      search_by = Rails.cache.read(sender_psid)
      searched_text = data[:message][:text]
      if search_by == 'COIN_BY_ID'
        { id: searched_text }
      else
        { name: searched_text }
      end
    end

    def selected_coins_params
      { id: data[:message][:quick_reply][:payload] }
    end

    def respond_to_messager
      @message.compact.each do |template|
        template.merge!({recipient: { id: sender_psid } })
        send_message(template)
      end
    end

    def send_message(request_body)
      HTTParty.post(
        'https://graph.facebook.com/v2.6/me/messages',
        :headers => {'Content-Type'=>'application/json'},
        query: { access_token: Rails.application.credentials.facebook[:page_access_token] },
        body: request_body.to_json
      )
    end
  end
end
