
module CoinGecko
  class Base < ApplicationService
    attr_reader :client, :response, :data

    def initialize(data)
      @data = (data || {}).with_indifferent_access
      @client = CoingeckoRuby::Client.new
    end

    def call
      return if data.blank?
      yield
      response
    ensure
      # add logging here
    end
  end
end
