
require "rails_helper"
RSpec.describe FacebookMessanger::UserName do
  describe '#call' do
    let(:sender_psid) { '5452370028140499' }
    let(:data) do
      {
        sender: {
          id: sender_psid
        }
      }
    end

    let(:response) { { first_name: 'Tauseeq', last_name: 'Tufail'} }

    before do
      stub_request(:get, 'https://graph.facebook.com/#{sender_psid}?fields=first_name,last_name&access_token=#{Rails.application.credentials.facebook[:page_access_token]}').
        to_return(status: 200, body: response.to_json)
    end

    it 'return first name' do
      expect(described_class.call(data)).to eq(response[:first_name])
    end
  end
end
