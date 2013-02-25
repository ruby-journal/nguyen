require 'nokogiri'

module Nguyen
  class Xfdf
    
    attr_reader :options
    
    def initialize(fields = {}, options = {})
      @fields = fields
      @options = {
        file: nil,
        id: nil
      }.merge(options)
    end

    # generate XFDF content
    def to_xfdf
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.xfdf('xmlns' => 'http://ns.adobe.com/xfdf/', 'xml:space' => 'preserve') {
          xml.f(href: options[:file]) if options[:file]
          xml.ids(original: options[:id], modified: options[:id]) if options[:id]
          xml.fields {
            @fields.each do |field, value|
              xml.field(name: field) {
                if value.is_a? Array
                  value.each { |item| xml.value(item.to_s) }
                else
                  xml.value(value.to_s)
                end
              }
            end
          }
        }
      end
      builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML)
    end

    # write fdf content to path
    def save_to(path)
      (File.open(path, 'w') << to_xfdf).close
    end

  end
end