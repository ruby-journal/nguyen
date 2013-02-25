require 'test_helper'

class XfdfTest < Test::Unit::TestCase
  def test_xfdf_generation
    xfdf = Nguyen::Xfdf.new(field1: 'fieldvalue1', other_field: 'some other value')
    assert xfdf_text = xfdf.to_xfdf
    assert_match /<field name="(field1)">.*<value>(fieldvalue1)<\/value>.*<\/field>/m, xfdf_text
    assert_match /<field name="(other_field)">.*<value>(some other value)<\/value>.*<\/field>/m, xfdf_text
  end
end
