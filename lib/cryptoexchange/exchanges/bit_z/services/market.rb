module Cryptoexchange::Exchanges
  module BitZ
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            true
          end
        end

        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          base = market_pair.base
          target = market_pair.target
          "#{Cryptoexchange::Exchanges::BitZ::Market::API_URL}/ticker?coin=#{base}_#{target}"
        end

        def adapt(output, market_pair)
          data = output["data"]
          ticker = Cryptoexchange::Models::Ticker.new
          ticker.base = market_pair.base
          ticker.target = market_pair.target
          ticker.market = BitZ::Market::NAME
          ticker.ask = NumericHelper.to_d(data['sell'])
          ticker.bid = NumericHelper.to_d(data['buy'])
          ticker.last = NumericHelper.to_d(data['last'])
          ticker.high = NumericHelper.to_d(data['high'])
          ticker.low = NumericHelper.to_d(data['low'])
          ticker.volume = NumericHelper.to_d(data['vol'])
          ticker.timestamp = DateTime.now.to_time.to_i
          ticker.payload = data
          ticker
        end
      end
    end
  end
end
