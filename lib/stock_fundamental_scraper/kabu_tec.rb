# 株テク提供のデータをスクレイピング
class KabuTec

  def initialize(company_fs)
    @company_fs = company_fs
  end

  # 株価情報
  def stock_info
    stock_info_node_set = @company_fs.search('//*[@id="cont_main"]/section[2]/div/table')

    stock_info_ary = stock_info_node_set[0].children.children[3].children.children.children.children.children.map(&:text)
    {
        stock_price: stock_info_node_set[0].children.children[1].children.children.text,
        stock_detail: stock_info_ary.each_slice(2).to_h
    }
  end

  # 財務指標
  def financial_statement
    fs_node_set = @company_fs.search('//*[@id="cont_main"]/section[4]/div/div/table')
    fs_ary = fs_node_set[0].children.children.children.map(&:text)
    fs_ary.each_slice(2).to_h
  end

  # 自動売買総合診断
  def auto_trace_judgment
    judgment_node_set = @company_fs.search('//*[@id="cont_main"]/section[3]/div/table')
    {
        auto_trace_judgment: judgment_node_set[0].children.children.children[0].attributes["alt"].value,
        reason: judgment_node_set[0].children.children.children[1].text
    }
  end
end