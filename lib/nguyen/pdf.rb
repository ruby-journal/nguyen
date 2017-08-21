module Nguyen
  class Pdf
    attr_reader :path

    def initialize(path, pdftk)
      @path = path
      raise IOError unless File.readable?(path)
      @pdftk = pdftk
    end

    def fields
      @fields ||= read_fields
    end

    protected

    def read_fields
      field_output = @pdftk.call_pdftk path, 'dump_data_fields_utf8'
      @fields = field_output.split("\n").map do |field_text|
        if field_text =~ /^FieldName: (.+)$/
          $1
        end
      end.compact.uniq
    end
  end
end
