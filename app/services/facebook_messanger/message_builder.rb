
module FacebookMessanger
  class MessageBuilder
    class << self
      def quick_reply(data)
        content = data.map do |coin|
          {
            "content_type": "text",
            "title": coin[:name],
            "payload": coin[:id]
          }
        end
    
        {
          "messaging_type": "RESPONSE",
          "message":{
            "text": "Search results:",
            "quick_replies": content
          }
        }
      end

      def text(content)
        {
          "message": {
            "text": "#{content}"
          }
        }
      end

      def button_template(buttons, content)
        {
          "message":{
            "attachment":{
              "type": "template",
              "payload": {
                "template_type": "button",
                "text": content,
                "buttons": build_buttons(buttons)
              }
            }
          }
        }
      end

      def build_buttons(buttons)
        buttons.map do |button|
          {
            "type": "postback",
            "title": button[:title],
            "payload": button[:payload]
          }
        end
      end
    end
  end
end
