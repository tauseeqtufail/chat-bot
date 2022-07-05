
require "rails_helper"
RSpec.describe FacebookMessanger::MessageBuilder do
  describe '#quick_reply' do
    let(:data) { [{ id: 'bitcoin', name: 'Bitcoin' } ] }
    let(:response) do
      {
        "messaging_type": "RESPONSE",
        "message":{
          "text": "Search results:",
          "quick_replies": [{
            "content_type": "text",
            "title": data[0][:name],
            "payload": data[0][:id]
          }]
        }
      }
    end
    it 'return quick_replies template' do
      expect(described_class.quick_reply(data)).to eq(response)
    end
  end

  describe '#text' do
    let(:message) { 'Welcome Tauseeq' }
    let(:response) do
      {
        "message": {
          "text": "#{message}"
        }
      }
    end
    it 'return text template' do
      expect(described_class.text(message)).to eq(response)
    end
  end

  describe '#button_template' do
    let(:content) { 'Search coins by?' }
    let(:buttons) { [{ title: 'ID', payload: 'COIN_BY_ID' }, { title: 'NAME', payload: 'COIN_BY_NAME' }]}
    let(:response) do
      {
        "message":{
          "attachment":{
            "type": "template",
            "payload": {
              "template_type": "button",
              "text": content,
              "buttons": [
                {
                  "type": "postback",
                  "title": buttons[0][:title],
                  "payload": buttons[0][:payload]
                },
                {
                  "type": "postback",
                  "title": buttons[1][:title],
                  "payload": buttons[1][:payload]
                }
              ]
            }
          }
        }
      }
    end
    it 'return button template' do
      expect(described_class.button_template(buttons, content)).to eq(response)
    end
  end
end
