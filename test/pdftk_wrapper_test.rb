require 'test_helper'

class FakeXfdf
  def save_to(path)
    true
  end
end

describe Nguyen::PdftkWrapper do

  let(:pdftk) { Nguyen::PdftkWrapper.new('pdftk') }
  let(:pdftk_options) { Nguyen::PdftkWrapper.new('pdftk', flatten: true, encrypt: true) }

  describe '#get_field_names' do
    it 'returns fields name' do
      fields = pdftk.get_field_names 'test/fixtures/form.pdf'
      fields.must_include 'program_name'
    end
  end

  describe '#fill_form' do
    describe 'input file is FDF' do
      let(:fdf) { Nguyen::Fdf.new(quote_of_the_day: 'You are beautiful') }

      it 'fills the PDF' do
        pdftk.fill_form('test/fixtures/form.pdf', 'output.pdf', fdf)
        assert File.size('output.pdf') > 0
        FileUtils.rm('output.pdf')
      end
    end

    describe 'input file ix XFDF' do
      let(:xfdf) { Nguyen::Xfdf.new(quote_of_the_day: 'I love you') }

      it 'fills the PDF' do
       pdftk.fill_form('test/fixtures/form.pdf', 'output.pdf', xfdf)
       assert File.size('output.pdf') > 0
       FileUtils.rm('output.pdf')
      end
    end

    describe 'when given an invalid xfdf file' do
      let(:not_an_xfdf_doc) { FakeXfdf.new }

      it 'raises an exception' do
        assert_raises(Nguyen::PdftkExecutionError) { pdftk.fill_form('test/fixtures/form.pdf', 'output.pdf', not_an_xfdf_doc) }
      end
    end
  end

  describe '#cat' do
    let(:pdf) { 'test/fixtures/form.pdf' }
    let(:pdf2) { 'test/fixtures/form2.pdf' }

    describe 'when given valid documents' do
      before do
        FileUtils.cp('test/fixtures/form.pdf', 'test/fixtures/form2.pdf')
      end

      it 'combines pdfs' do
        pdftk.cat(pdf, pdf2, 'output.pdf')
        assert File.size('output.pdf') > File.size('test/fixtures/form.pdf')
        FileUtils.rm('output.pdf')
      end

      it 'allows a wildcard to combine pdfs' do
        pdftk.cat('test/fixtures/form*.pdf', 'output.pdf')
        assert File.size('output.pdf') > File.size('test/fixtures/form.pdf')
        FileUtils.rm('output.pdf')
      end

      after do
        FileUtils.rm('test/fixtures/form2.pdf')
      end
    end

    describe 'when given invalid documents' do
      it 'raises a PdftkExecutionError' do
        assert_raises(Nguyen::PdftkExecutionError) { pdftk.cat(pdf, pdf2, 'output.pdf') }
      end
    end
  end
end
