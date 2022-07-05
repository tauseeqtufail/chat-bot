

module CoinGecko
  class HistoricalPrice < CoinGecko::Base
    # CoinGecko::HistoricalPrice.call({ id: string })
    # Returns array of Hashes [{ date: '12-06-2022', price: '$888' }, ...]
    # TODO Either use switch case in call to support multiple price methods or create modular approche
    def call
      super do
        # Return historical_prices
        historical_prices =
          client.get_daily_historical_prices(id: data[:id], days: data[:days] || 13)['prices']
        prepare_response(historical_prices)
      end
    end

    private

    def prepare_response(prices)
      @response = []
      prices.reverse.each do |time_and_price|
        date = Time.at(time_and_price[0]/1000).strftime("%d-%m-%Y")
        price = "$#{time_and_price[1].round(2)}"
        @response.push({ date: date, price: price })
      end
    end
  end
end
