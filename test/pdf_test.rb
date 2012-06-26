require 'test_helper'

class PdfTest < Test::Unit::TestCase

  def setup
    @pdftk = Nguyen::PdftkWrapper.new 'pdftk'
  end

  def test_fields    
    pdf = Nguyen::Pdf.new 'test/fixtures/form.pdf', @pdftk
    assert fields = pdf.fields
    assert fields.any?
    assert fields.include?('program_name')
  end

  def test_should_error_when_file_not_readable
    assert_raises(IOError){
      Nguyen::Pdf.new 'foo/bar.pdf', @pdftk
    }
  end
end