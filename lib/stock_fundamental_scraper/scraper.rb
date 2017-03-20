require 'mechanize'
require 'pry'
require 'stock_fundamental_scraper/kabu_tec'
require 'stock_fundamental_scraper/rakuten_sec'

module StockFundamentalScraper
  class Scraper

    def initialize(stock_code: stock_code,
                   kabu_tec: false,
                   rakuten_sec: false,
                   kabu_tan: false,
                   kabu_sensor: false
    )

      if kabu_tec
        # 株テクデータ取得用インスタンス
        @kabutec = KabuTec.new(scrape_page("https://www.kabutec.jp/company/fs_#{stock_code}.html"))
      end

      if rakuten_sec
        # 楽天証券データ取得用インスタンス
        @rakuten_sec_pl = RakutenSecPL.new(scrape_page("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{stock_code}.T&c=ja&ind=2&fs=1"))
        ## 同ドメインサイトへのアクセスなので5秒のインターバルをおく
        sleep(3)
        @rakuten_sec_bs = RakutenSecBS.new(scrape_page("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{stock_code}.T&c=ja&ind=2&fs=2"))
        ## 同ドメインサイトへのアクセスなので5秒のインターバルをおく
        sleep(3)
        @rakuten_sec_cf = RakutenSecCF.new(scrape_page("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{stock_code}.T&c=ja&ind=2&fs=3"))
      end


      if kabu_tan
        # 株探データ取得用インスタンス
        ## 本日活況銘柄（約定回数上位50社）
        @kabutan_briskness = KabuTanBriskness.new(scrape_page("https://kabutan.jp/warning/?mode=2_9"))
      end

      if kabu_sensor
        
      end

      ##
      ##
      ##
      ##
      ##
      ##
      ##
      ##
      ##



    end


    def kabu_tec
      @kabutec
    end

    def rakuten_sec_pl
      @rakuten_sec_pl.pl
    end

    def rakuten_sec_bs
      @rakuten_sec_bs.bs
    end

    def rakuten_sec_cf
      @rakuten_sec_cf.cf
    end


    private

    # スクレイピングを実施し、Mechanizeインスタンスを取得
    def scrape_page(url)
      agent = Mechanize.new
      scrape_instance = nil
      10.times do
        begin
          scrape_instance = agent.get(url)
        rescue => e
          sleep(2)
          next
        end

        if scrape_instance.nil?
          sleep(2)
          next
        end

        if scrape_instance.code == "200"
          break
        end
      end

      scrape_instance
    end

  end
end