

module CoinGecko
  class HistoricalPrice < CoinGecko::Base
    # CoinGecko::HistoricalPrice.call({ id: string })
    # Returns array of Hashes [{id: 'bitcoins', name: 'Bitcoins'}, ...]
    def call
      super do
        # Return historical_prices
        historical_prices =
          client.get_daily_historical_prices(id: data[:id], days: data[:days] || 14)['prices']
        prepare_response(historical_prices)
      end
    end

    private

    def prepare_response(prices)
      @response = []
      prices.reverse.each do |time_and_price|
        date = Time.at(time_and_price[0]/1000).strftime("%d-%m-%Y")
        price = "$#{time_and_price[1]}"
        @response.push({ date: date, price: price })
      end
    end
  end
end