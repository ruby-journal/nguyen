require 'test_helper'

describe Nguyen::Pdf do
  let(:pdftk) { Nguyen::PdftkWrapper.new 'pdftk' }

  describe '#fields' do
    let(:pdf) { Nguyen::Pdf.new 'test/fixtures/form.pdf', pdftk }
    it 'returns extracted fields from PDF' do
      fields = pdf.fields
      _(fields.any?).must_equal true
      _(fields).must_include 'program_name'
    end
  end

  describe '#new' do
    it 'reaise IOError if cannot read PDF file' do
      _(proc { Nguyen::Pdf.new 'foo/bar.pdf', pdftk }).must_raise IOError
    end
  end
end
