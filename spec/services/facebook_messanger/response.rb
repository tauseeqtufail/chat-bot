
require "rails_helper";
RSpec.describe FacebookMessanger::Response do
  describe '#call' do
    before do
      allow(FacebookMessanger::MessageBuilder).to receive(:text).and_return(nil)
    end
    context 'when seach coin' do
      let(:data) do
        {
          message: {
            quick_reply: { payload: 'bitcoin-cash-sv' }
          },
          sender: {
            id: '55555'
          }
        }
      end
      before do
        allow(CoinGecko::HistoricalPrice).to receive(:call).and_return([date: '12-03-2022', price: '$444.44'])
      end

      it 'call HistoricalPrice method' do
        described_class.call(data)
        expect(CoinGecko::HistoricalPrice).to have_received(:call)
      end

      it 'call build text message' do
        described_class.call(data)
        expect(FacebookMessanger::MessageBuilder).to have_received(:text)
      end
    end

    context 'display welcom message and show seach type button' do
      let(:data) do
        {
          message: {
            text: 'hi'
          },
          sender: {
            id: '55555'
          }
        }
      end
      before do
        allow(FacebookMessanger::UserName).to receive(:call).and_return('Tauseeq')
        allow(FacebookMessanger::MessageBuilder).to receive(:button_template).and_return(nil)
      end

      it 'call FacebookMessanger::UserName method' do
        described_class.call(data)
        expect(FacebookMessanger::UserName).to have_received(:call)
      end

      it 'call build text message' do
        described_class.call(data)
        expect(FacebookMessanger::MessageBuilder).to have_received(:text)
      end

      it 'call build button template' do
        described_class.call(data)
        expect(FacebookMessanger::MessageBuilder).to have_received(:button_template)
      end
    end
  end
end
