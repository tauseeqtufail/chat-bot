
require "rails_helper"
RSpec.describe CoinGecko::HistoricalPrice do
  let(:params) { { id: 'wrapped-ampleforth', days: 13 } }
  subject(:response) { described_class.call(params) }
  describe 'search by coin id' do
    it 'return 14 prices with dates' do
      expect(response.length).to eq(14)
    end
    it "includes date key" do
      expect(response.first).to have_key(:date)
    end
    it "includes price key" do
      expect(response.first).to have_key(:price)
    end
  end
end
