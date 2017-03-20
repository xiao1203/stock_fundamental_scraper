# 株探提供のデータをスクレイピング
class KabuTanBriskness
  def initialize(company_fs)
    @company_fs = company_fs
  end

  # 本日活況銘柄
  def get_data
    node_set = @company_fs.search('//*[@id="main"]/div[5]/table')
    node_ary = node_set.children.children.children.map(&:text)
    # 取得したデータを整形
    node_ary.select!{|text| text != "\r\n"}
    node_ary = node_ary.map do |text|
      if text == "－%"
        ["－", "%"]
      else
        text
      end
    end
    node_ary.delete("S")
    node_ary.delete("ｹ")
    node_ary.flatten!

    node_ary.insert(3, "")
    node_ary[6] = "前日差額"
    node_ary.insert(8, "")
    node_table = node_ary.each_slice(13).to_a
    node_table.map { |row| row.delete_at(3) }
    node_table.map { |row| row.delete_at(3) }

    # TODO 最適な返却形式をもう少し考察する
    node_table
  end
end
