
module CoinGecko
  class Search < CoinGecko::Base
    # CoinGecko::Search.call({ search_keyword: string })
    # Returns array of Hashes [{id: 'bitcoins', name: 'Bitcoins'}, ...]
    def call
      super do
        # Return first five coins
        coins_list = client.search(data[:search_keyword])['coins'].first(5)
        prepare_response(coins_list)
      end
    end

    private

    def prepare_response(list)
      @response = []
      list.each do |coin|
        @response.push({ id: coin['id'], name: coin['name'] })
      end
    end
  end
end
