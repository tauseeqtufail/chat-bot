
module CoinGecko
  class Search < CoinGecko::Base
    # CoinGecko::Search.call({ id: string or name: string })
    # Returns array of Hashes [{id: 'bitcoins', name: 'Bitcoins'}, ...]
    def call
      super do
        # Return first five coins
        begin
          coins_list = if data[:id].present?
              name = client.coin(data[:id])['name']
              [{ id: data[:id], name: name }]
            else
              client.search(data[:name])['coins'].first(5)
            end
        rescue CoingeckoRuby::ResourceNotFound => e
          raise Exceptions::ExternalError.new('Record not found', 404)
        end
        prepare_response(coins_list)
      end
    end

    private

    def prepare_response(list)
      @response = []
      list.each do |coin|
        coin = (coin || {}).with_indifferent_access
        @response.push({ id: coin[:id], name: coin[:name] })
      end
    end
  end
end
