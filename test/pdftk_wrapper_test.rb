require 'test_helper'

class PdftkWrapperTest < Test::Unit::TestCase

  def setup
    @pdftk = Nguyen::PdftkWrapper.new('pdftk')
    @pdftk_options = Nguyen::PdftkWrapper.new('pdftk', flatten: true, encrypt: true)
  end

  def test_field_names
    assert fields = @pdftk.get_field_names('test/fixtures/form.pdf')
    assert fields.any?
    assert fields.include?('program_name')
  end

  def test_fill_form_with_fdf
    @fdf = Nguyen::Fdf.new(quote_of_the_day: 'You are beautiful')
    @pdftk.fill_form('test/fixtures/form.pdf', 'output.pdf', @fdf)
    assert File.size('output.pdf') > 0
    FileUtils.rm('output.pdf')
  end

  def test_fill_form_with_xfdf
    @xfdf = Nguyen::Xfdf.new(quote_of_the_day: 'I love you')
    @pdftk.fill_form('test/fixtures/form.pdf', 'output.pdf', @xfdf)
    assert File.size('output.pdf') > 0
    FileUtils.rm('output.pdf')
  end

  def test_fill_form_encrypted_and_flattened
    @xfdf = Nguyen::Xfdf.new(quote_of_the_day: 'I love you')
    @pdftk_options.fill_form('test/fixtures/form.pdf', 'output.pdf', @xfdf)
    assert File.size('output.pdf') > 0
    FileUtils.rm('output.pdf')
  end

end
