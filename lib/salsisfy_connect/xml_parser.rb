require 'ox'
require 'json'

#we will use the Sax handler..more code but 40 times faster than Nokogiri
class XmlParser
  class ProductSaxHandler < ::Ox::Sax
    attr_reader :products

    def initialize
      super
      @products = []
      @current_product = nil
      @current_element = nil
    end

    # start
    def start_element(name)
      if name == :product
        @current_product = {}
      else
        @current_element = name
      end
    end

    #clean up keys
    def format_key(name)
      name.to_s.gsub('_', ' ')
    end

    # get attributes
    def attr(name, value)
      @current_product[format_key(name)] = value if @current_product
    end

    # get the text
    def text(value)
      return unless @current_product && @current_element
      @current_product[format_key(@current_element)] = value.strip
    end

    # closing tags
    def end_element(name)
      if name == :product
        @products << @current_product
        @current_product = nil
      else
        @current_element = nil
      end
    end
  end

  # parsing
  def self.parse(xml_file, json_file)
    handler = ProductSaxHandler.new
    File.open(xml_file) do |f|
      Ox.sax_parse(handler, f)
    end

    json_string = JSON.pretty_generate(handler.products)
    File.write(json_file, json_string)
    json_file
  end
end


if __FILE__ == $0
  xml_file = 'products.xml'
  json_file = 'products.json'
  output = XmlParser.parse(xml_file, json_file)
  puts "Parsed to JSON: #{output}"
end