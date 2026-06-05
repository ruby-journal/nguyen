require 'test_helper'

describe Nguyen::PdftkWrapper do

  let(:pdftk) { Nguyen::PdftkWrapper.new('pdftk') }
  let(:pdftk_options) { Nguyen::PdftkWrapper.new('pdftk', flatten: true, encrypt: true) }

  describe '#get_field_names' do
    it 'returns fields name' do
      fields = pdftk.get_field_names 'test/fixtures/form.pdf'
      _(fields).must_include 'program_name'
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

    describe 'input file is xfdf xml string' do
      let(:xfdf) { Nguyen::Xfdf.new(quote_of_the_day: 'I love you').to_xfdf }

      it 'fills the PDF' do
        pdftk.fill_form('test/fixtures/form.pdf', 'output.pdf', xfdf)
        assert File.size('output.pdf') > 0
        FileUtils.rm('output.pdf')
      end
    end

    describe 'radio buttons and checkboxes' do
      def field_value(pdf_path, field_name)
        dump = pdftk.call_pdftk %Q("#{pdf_path}"), 'dump_data_fields_utf8'
        block = dump.split(/^---$/).find { |b| b =~ /^FieldName: #{Regexp.escape(field_name)}$/ }
        block && block[/^FieldValue: (.*)$/, 1]
      end

      describe 'with XFDF export values' do
        let(:xfdf) do
          Nguyen::Xfdf.new(
            child_gender: '1',                          # radio with 1/0 states
            caregiver_relationship_to_child: 'Parent',  # radio with named states
            area1_answer1: 'YES',                       # checkboxes
            area1_answer2: 'SOMETIMES',
            area1_answer3: 'NOT YET'
          )
        end

        it 'ticks the boxes matching the export values' do
          pdftk.fill_form('test/fixtures/form.pdf', 'output.pdf', xfdf)
          _(field_value('output.pdf', 'child_gender')).must_equal '1'
          _(field_value('output.pdf', 'caregiver_relationship_to_child')).must_equal 'Parent'
          _(field_value('output.pdf', 'area1_answer1')).must_equal 'YES'
          _(field_value('output.pdf', 'area1_answer2')).must_equal 'SOMETIMES'
          _(field_value('output.pdf', 'area1_answer3')).must_equal 'NOT YET'
          # untouched checkbox stays unticked
          _(field_value('output.pdf', 'area1_answer4')).must_be_nil
          FileUtils.rm('output.pdf')
        end
      end

      describe 'with FDF booleans' do
        let(:fdf) { Nguyen::Fdf.new(child_gender: true) }

        it 'ticks the box via the true => /1 mapping' do
          pdftk.fill_form('test/fixtures/form.pdf', 'output.pdf', fdf)
          _(field_value('output.pdf', 'child_gender')).must_equal '1'
          FileUtils.rm('output.pdf')
        end
      end
    end
  end

  describe '#stamp' do
    def page_count(pdf_path)
      dump = pdftk.call_pdftk %Q("#{pdf_path}"), 'dump_data'
      dump[/^NumberOfPages: (\d+)$/, 1].to_i
    end

    it 'overlays the stamp onto every page of the source' do
      pdftk.stamp('test/fixtures/form.pdf', 'test/fixtures/stamp.pdf', 'output.pdf')
      assert File.size('output.pdf') > 0
      _(page_count('output.pdf')).must_equal page_count('test/fixtures/form.pdf')
      FileUtils.rm('output.pdf')
    end

    it 'raises PdftkError when the stamp file does not exist' do
      _(proc {
        pdftk.stamp('test/fixtures/form.pdf', 'no/such/stamp.pdf', 'output.pdf')
      }).must_raise Nguyen::PdftkError
    end
  end

  describe '#multistamp' do
    it 'overlays the stamp onto the source page by page' do
      pdftk.multistamp('test/fixtures/form.pdf', 'test/fixtures/stamp.pdf', 'output.pdf')
      assert File.size('output.pdf') > 0
      FileUtils.rm('output.pdf')
    end
  end

  describe '#cat' do

    before do
      FileUtils.cp('test/fixtures/form.pdf', 'test/fixtures/form2.pdf')
    end

    let(:pdf) { 'test/fixtures/form.pdf' }
    let(:pdf2) { 'test/fixtures/form2.pdf' }

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
end
