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
      hs[:name] = @company_fs.search('//*[@id="cancel"]/div[' + (num + 1).to_s + ']/div/div[2]/div[1]/h3').text
      hs[:signal] = @company_fs.search('//*[@id="cancel"]/div[' + (num + 1).to_s + ']/div/div[2]/div[2]/ul/li[2]/a')[0].text
      hs[:others] = @company_fs.search('//*[@id="cancel"]/div[' + (num + 1).to_s + ']/div/div[2]/div[2]/ul/li[2]/a')[0].attributes["title"].value
      hs[:price] = @company_fs.search('//*[@id="cancel"]/div[' + (num + 1).to_s + ']/div/div[2]/div[3]/ul/li[2]/span').text
      hs[:before_retio] = @company_fs.search('//*[@id="cancel"]/div[' + (num + 1).to_s + ']/div/div[2]/div[3]/ul/li[3]/span').text
      result << hs
    end
    result
  end
end