require 'test_helper'

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
  end
end
