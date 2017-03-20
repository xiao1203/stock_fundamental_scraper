# StockFundamentalScraper

様々な株情報提供サイトにスクレイピングを行い、情報を取得するGem
yahooファイナンスは禁止されているので対象外
しかし、他のサイトも極力負荷をかけたくないので、本Gemは取得した後、Redis等で
同日に同じ情報を取得しにいかない、などの配慮が必要。
Gemではそこまでの機能は持たせられないので、Rails API アプリケーション作るときに
対応します。

## Installation
rubyGemにあげるつもりはありません。
野良Gemなので使いたかったら落とすか、

```ruby
gem 'stock_fundamental_scraper', github: 'mxiao1203/stock_fundamental_scraper'
```

としてください。
（未検証）

## Usage
実装者以外が本Gemを使うことは想定していないので、
使い方は省略。
APIサーバー立てるのでそっちをみてください。

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

