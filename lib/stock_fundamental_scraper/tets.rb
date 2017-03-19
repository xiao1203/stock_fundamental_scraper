require 'mechanize'
require 'pry'
require 'stock_fundamental_scraper/kabu_tec'

module StockFundamentalScraper

  def self.greet
    puts "hhhhhh"
  end

  class Scraper

    def initialize(stock_code)
      @kabutec = KabuTec.new(scrape_page("https://www.kabutec.jp/company/fs_#{stock_code}.html"))
    end

    def kabu_tec
      @kabutec
    end

    private

    def scrape_page(url)
      agent = Mechanize.new
      scrape_instance = nil
      10.times do
        begin
          scrate_instance = agent.get(url)
        rescue => e
          sleep(2)
          next
        end

        if scrate_instance.nil?
          sleep(2)
          next
        end

        if (scrate_instance.code == "200")
          break
        end
      end

      scrape_instance
    end

  end
end