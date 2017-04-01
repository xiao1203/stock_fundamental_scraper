# 株センサー提供のデータをスクレイピング
class KabuSensor
  def initialize(company_fs)
    @company_fs = company_fs
  end

  # シグナル発生銘柄の情報を取得
  def get_data
    # 10件のデータを取得
    result = []
    10.times do |num|
      hs = {}

      hs[:name] = @company_fs.search("/html/body/div[2]/div/div[1]/div[5]/div[#{num + 1}]/div/div[2]/div[1]/h3").text
      hs[:signals_num] = @company_fs.search("/html/body/div[2]/div/div[1]/div[5]/div[#{num + 1}]/div/div[2]/div[2]/div[2]/span").text
      hs[:price] = @company_fs.search("/html/body/div[2]/div/div[1]/div[5]/div[#{num + 1}]/div/div[2]/div[3]/ul/li[2]/span").text
      hs[:before_retio] = @company_fs.search("/html/body/div[2]/div/div[1]/div[5]/div[#{num + 1}]/div/div[2]/div[3]/ul/li[3]/span").text
      result << hs
    end
    result
  end
end