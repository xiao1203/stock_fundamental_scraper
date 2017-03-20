# 楽天証券提供のデータをスクレイピング
module RakutenSec
  class PL
    def initialize(company_fs)
      @company_fs = company_fs
    end

    # PL
    def pl
      pl_node_set = @company_fs.search('//*[@id="str-main"]/table[3]')
      pl_ary = pl_node_set.children.children.children.map(&:text)
      pl_table = pl_ary.each_slice(5).to_a

      header = pl_table[0]
      pl_table.each_with_object([]).with_index do |(row, result),i|
        next if i == 0

        summary = {}
        row.each_with_index do |value, index|
          if index == 0
            summary[:summary_name] = value
          else
            if summary[:values].nil?
              summary[:values] = []
            end
            summary[:values] << {
                term: header[index],
                value: value
            }
          end
        end
        result << summary
      end
    end
  end

  class BS
    def initialize(company_fs)
      @company_fs = company_fs
    end

    # BS
    def bs
      bs_node_set = @company_fs.search('//*[@id="str-main"]/table[3]')
      bs_array = bs_node_set[0].children.children.children.map(&:text)
      bs_table = bs_array.each_slice(5).to_a

      header = bs_table[0]

      cash_start_index = bs_table.index { |row| row.include?("資産の部") }
      dept_start_index = bs_table.index { |row| row.include?("負債の部") }
      capital_start_index = bs_table.index { |row| row.include?("資本の部") }

      result = {
          cash_category: {
              name: "資産の部",
              summaries: []
          },
          dept_category: {
              name: "負債の部",
              summaries: []
          },
          capital_categpry: {
              name: "資本の部",
              summaries: []
          }
      }

      bs_table.each_with_index do |row, index|
        next if [cash_start_index, dept_start_index, capital_start_index].include?(index)

        summary = {}
        row.each_with_index do |value, row_index|
          if row_index == 0
            summary[:summary_name] = value
          else
            if summary[:values].nil?
              summary[:values] = []
            end
            summary[:values] << {
                term: header[index],
                value: value
            }
          end
        end

        if index > cash_start_index && dept_start_index > index
          # 資産の部
          result[:cash_category][:summaries] << summary
        elsif index > dept_start_index && capital_start_index > index
          # 負債の部
          result[:dept_category][:summaries] << summary
        else
          # 資本の部
          result[:capital_categpry][:summaries] << summary
        end
      end

      result
    end
  end

  class CF
    def initialize(company_fs)
      @company_fs = company_fs
    end

    # CF
    def cf
      cf_node_set = @company_fs.search('//*[@id="str-main"]/table[3]')

      cf_array = cf_node_set[0].children.children.children.map(&:text)
      cf_table = cf_array.each_slice(5).to_a

      header = cf_table[0]
      cf_table.each_with_object([]).with_index do |(row, result),i|
        next if i == 0

        summary = {}
        row.each_with_index do |value, index|
          if index == 0
            summary[:summary_name] = value
          else
            if summary[:values].nil?
              summary[:values] = []
            end
            summary[:values] << {
                term: header[index],
                value: value
            }
          end
        end
        result << summary
      end
    end
  end
end
