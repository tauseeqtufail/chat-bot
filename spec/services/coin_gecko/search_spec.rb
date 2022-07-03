
require "rails_helper"
RSpec.describe CoinGecko::Search do
  let(:params) { { id: id, name: name } }
  subject(:response) { described_class.call(params) }
  describe 'search by coin id' do
    let(:name) { '' }
    context 'with valid coin id' do
      let(:id) { 'wrapped-ampleforth' }

      it 'return single coin when valid coin id searched' do
        expect(response).to eq([{ id: id, name: 'Wrapped Ampleforth' }])
      end
    end

    context 'with invalid coin id' do
      let(:id) { 'wrapped-ampleforthffffff' }

      it 'return exception record not found' do
        expect do
          response
        end.to raise_error(Exceptions::ExternalError)
      end
    end
  end

  describe 'search by coin name' do
    let(:id) { false }
    context 'with valid coin name' do
      let(:name) { 'Bitcoin' }

      it 'return 5 matching coins' do
        expect(response.length).to eq(5)
      end
    end

    context 'with invalid coin name' do
      let(:name) { 'ddfadwrapped-ampleforthffffff' }

      it 'return empty record' do
        expect(response).to eq([])
      end
    end
  end
end
