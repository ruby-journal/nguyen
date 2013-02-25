require 'test_helper'

describe Nguyen::Pdf do
  let(:pdftk) { Nguyen::PdftkWrapper.new 'pdftk' }

  describe '#fields' do
    let(:pdf) { Nguyen::Pdf.new 'test/fixtures/form.pdf', pdftk }
    it 'returns extracted fields from PDF' do  
      fields = pdf.fields
      fields.any?.must_equal true
      fields.must_include 'program_name'
    end
  end

  describe '#new' do
    it 'reaise IOError if cannot read PDF file' do
      proc { Nguyen::Pdf.new 'foo/bar.pdf', pdftk }.must_raise IOError
    end
  end
end
