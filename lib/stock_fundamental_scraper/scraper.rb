require 'mechanize'
require 'pry'
require 'stock_fundamental_scraper/kabu_tec'
require 'stock_fundamental_scraper/rakuten_sec'
require 'stock_fundamental_scraper/kabu_sensor'
require 'stock_fundamental_scraper/kabu_tan'

module StockFundamentalScraper
  class Scraper

    def initialize(stock_code: nil,
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
        @rakuten_sec_pl = RakutenSec::PL.new(scrape_page("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{stock_code}.T&c=ja&ind=2&fs=1"))
        ## 同ドメインサイトへのアクセスなので5秒のインターバルをおく
        sleep(3)
        @rakuten_sec_bs = RakutenSec::BS.new(scrape_page("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{stock_code}.T&c=ja&ind=2&fs=2"))
        ## 同ドメインサイトへのアクセスなので5秒のインターバルをおく
        sleep(3)
        @rakuten_sec_cf = RakutenSec::CF.new(scrape_page("https://www.trkd-asia.com/rakutensec/quote.jsp?ric=#{stock_code}.T&c=ja&ind=2&fs=3"))
      end

      if kabu_tan
        # 株探データ取得用インスタンス
        ## 本日活況銘柄（約定回数上位50社）
        @kabutan_briskness = KabuTanBriskness.new(scrape_page("https://kabutan.jp/warning/?mode=2_9"))
      end

      if kabu_sensor
        # ボリンジャー(10日)買いシグナル1P
        @kabu_sensor_boli_buy_10_1 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/kai/?page=1&t_cd=1&s_cd=1"))
        sleep(2)

        # ボリンジャー(10日)買いシグナル2P
        @kabu_sensor_boli_buy_10_2 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/kai/?page=2&t_cd=1&s_cd=1"))
        sleep(2)

        # ボリンジャー(10日)売りシグナル1P
        @kabu_sensor_boli_sell_10_1 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/uri/?page=1&t_cd=1&s_cd=1"))
        sleep(2)

        # ボリンジャー(10日)売りシグナル2P
        @kabu_sensor_boli_sell_10_2 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/uri/?page=2&t_cd=1&s_cd=1"))
        sleep(2)

        # ボリンジャー(25日)買いシグナル1P
        @kabu_sensor_boli_buy_25_1 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/kai/?page=1&t_cd=1&s_cd=2"))
        sleep(2)

        # ボリンジャー(25日)買いシグナル2P
        @kabu_sensor_boli_buy_25_2 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/kai/?page=2&t_cd=1&s_cd=2"))
        sleep(2)

        # ボリンジャー(25日)売りシグナル1P
        @kabu_sensor_boli_sell_25_1 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/uri/?page=1&t_cd=1&s_cd=2"))
        sleep(2)

        # ボリンジャー(25日)売りシグナル2P
        @kabu_sensor_boli_sell_25_2 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/uri/?page=2&t_cd=1&s_cd=2"))
        sleep(2)

        # 乖離率 買いシグナル1P
        @kabu_sensor_kairi_buy_1 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/kai/?page=1&t_cd=5&s_cd=1"))
        sleep(2)

        # 乖離率 買いシグナル2P
        @kabu_sensor_kairi_buy_2 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/kai/?page=2&t_cd=5&s_cd=1"))
        sleep(2)

        # 乖離率 売りシグナル1P
        @kabu_sensor_kairi_sell_1 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/uri/?page=1&t_cd=5&s_cd=1"))
        sleep(2)

        # 乖離率 売りシグナル2P
        @kabu_sensor_kairi_sell_2 = KabuSensor.new(scrape_page("http://kabusensor.com/signal/uri/?page=2&t_cd=5&s_cd=1"))
        sleep(2)

        # サイコロジカルサイン 買いシグナル
        @kabu_sensor_psycho_buy = KabuSensor.new(scrape_page("http://kabusensor.com/signal/kai/?page=1&t_cd=4&s_cd=1"))
        sleep(2)

        # サイコロジカルサイン 売りシグナル
        @kabu_sensor_psycho_sell = KabuSensor.new(scrape_page("http://kabusensor.com/signal/uri/?page=1&t_cd=4&s_cd=1"))
        sleep(2)

        # RSI 買いシグナル
        @kabu_sensor_rsi_buy = KabuSensor.new(scrape_page("http://kabusensor.com/signal/kai/?t_cd=6&s_cd=1"))
        sleep(2)

        # RSI 売りシグナル
        @kabu_sensor_rsi_sell = KabuSensor.new(scrape_page("http://kabusensor.com/signal/uri/?t_cd=6&s_cd=1"))
        sleep(2)

        # MACD 買いシグナル
        @kabu_sensor_macd_buy = KabuSensor.new(scrape_page("http://kabusensor.com/signal/kai/?t_cd=10&s_cd=1"))
        sleep(2)

        # MACD 売りシグナル
        @kabu_sensor_macd_sell = KabuSensor.new(scrape_page("http://kabusensor.com/signal/uri/?t_cd=10&s_cd=1"))
        sleep(2)

        # 買いシグナル多数
        @kabu_sensor_buy_signal = KabuSensor.new(scrape_page("http://kabusensor.com/ranking/kaisignal/"))
        sleep(2)

        # 売りシグナル多数
        @kabu_sensor_sell_signal = KabuSensor.new(scrape_page("http://kabusensor.com/ranking/urisignal/"))
      end
    end

    # 株テク：株価情報
    def kabu_tec_stock_info
      @kabutec.stock_info
    end

    # 株テク：財務指標
    def kabu_tec_financial_statement
      @kabutec.financial_statement
    end

    # 株テク：自動売買総合診断
    def kabu_tec_auto_trace_judgment
      @kabutec.auto_trace_judgment
    end

    # 楽天証券：PL
    def rakuten_sec_pl
      @rakuten_sec_pl.pl
    end

    # 楽天証券：BS
    def rakuten_sec_bs
      @rakuten_sec_bs.bs
    end

    # 楽天証券：CF
    def rakuten_sec_cf
      @rakuten_sec_cf.cf
    end

    # 株探：本日活況銘柄
    def kabu_tan_briskness
      @kabutan_briskness.get_data
    end

    # 株センサー：ボリンジャー10日買いシグナル
    def kabu_sensor_bollinger_ten_buy
      @kabu_sensor_boli_buy_10_1.get_data + @kabu_sensor_boli_buy_10_2.get_data
    end

    # 株センサー：ボリンジャー10日売りシグナル
    def kabu_sensor_bollinger_ten_sell
      @kabu_sensor_boli_sell_10_1.get_data + @kabu_sensor_boli_sell_10_2.get_data
    end

    # 株センサー：ボリンジャー25日買いシグナル
    def kabu_sensor_bollinger_twentyfive_buy
      @kabu_sensor_boli_buy_25_1.get_data + @kabu_sensor_boli_buy_25_2.get_data
    end

    # 株センサー：ボリンジャー25日売りシグナル
    def kabu_sensor_bollinger_twentyfive_sell
      @kabu_sensor_boli_sell_25_1.get_data + @kabu_sensor_boli_sell_25_2.get_data
    end

    # 株センサー：乖離率 買いシグナル
    def kabu_sensor_kairi_buy
      @kabu_sensor_kairi_buy_1.get_data + @kabu_sensor_kairi_buy_2.get_data
    end
    
    # 株センサー：乖離率 売りシグナル
    def kabu_sensor_kairi_sell
      @kabu_sensor_kairi_sell_1.get_data + @kabu_sensor_kairi_sell_2.get_data
    end

    # 株センサー：サイコロジカルサイン 買いシグナル
    def kabu_sensor_psycho_buy
      @kabu_sensor_psycho_buy.get_data
    end
    
    # 株センサー：サイコロジカルサイン 売りシグナル
    def kabu_sensor_psycho_sell
      @kabu_sensor_psycho_sell.get_data
    end

    # 株センサー：RSI 買いシグナル
    def kabu_sensor_rsi_buy
      @kabu_sensor_rsi_buy.get_data
    end

    # 株センサー：RSI 売りシグナル
    def kabu_sensor_rsi_sell
      @kabu_sensor_rsi_sell.get_data
    end

    # 株センサー：MACD 買いシグナル
    def kabu_sensor_macd_buy
      @kabu_sensor_macd_buy.get_data
    end

    # 株センサー：MACD 売りシグナル
    def kabu_sensor_macd_sell
      @kabu_sensor_macd_sell.get_data
    end

    # 株センサー：買いシグナル多数
    def kabu_sensor_buy_signal
      @kabu_sensor_buy_signal.get_data
    end

    # 株センサー：
    def kabu_sensor_sell_signal
      @kabu_sensor_sell_signal.get_data
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