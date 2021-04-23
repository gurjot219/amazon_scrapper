require "watir"
require "httparty"
require "webdrivers"
require "nokogiri"
require "byebug"
require "sequel"
require_relative "database.rb"

class Scrapper
  extend Database

  def scrap
    puts "Table has been created" if Scrapper.create_table
    chrome = browser
    chrome.goto(url)
    chrome.text_field(id: 'twotabsearchtextbox').set(product_name)
    chrome.button(id: "nav-search-submit-button").click
    fetch_data(chrome.url)
  end

  private

  def fetch_data(url)
    unparsed_html = HTTParty.get(url)
    parsed_html   = Nokogiri::HTML(unparsed_html)
    parse_data(parsed_html)
  end

  def parse_data(html)
    products = html.css("div.s-result-item")
    products.each do |product|
      name  = product.css("span.a-size-medium").text
      price = product.css("span.a-price-whole").text
      Scrapper.insert(name, price)
    end
    debugger
  end

  def browser
    Watir::Browser.new #it will open chrome
  end

  def url
    "https://www.amazon.in/"
  end

  def product_name
    "LG-Inverter-Direct-Cool-Refrigerator-GL-D201ASCY"
  end
end

Scrapper.new.scrap
