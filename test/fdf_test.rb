require 'test_helper'

describe Nguyen::Fdf do
  describe '#to_fdf' do
    let(:fdf) { Nguyen::Fdf.new field1: 'fieldvalue1', other_field: 'some other value' }
    
    it 'generates fdf' do
      assert fdf_text = fdf.to_fdf
      assert_match %r{<</T\(field1\)/V\(fieldvalue1\)>>}, fdf_text
      assert_match %r{<</T\(other_field\)/V\(some other value\)>>}, fdf_text
    end

    describe 'hash value has quotes' do
      let(:quote_fdf) { Nguyen::Fdf.new field1: 'field(va)lue1' }
      it 'generates correct escaped quotes fdf' do
        assert_match '<</T(field1)/V(field\(va\)lue1)>>', quote_fdf.to_fdf
      end
    end

    describe 'hash value has multiple values' do
      let(:multi_values_fdf) { Nguyen::Fdf.new field1: %w(one two) }
      it 'generates correct escaped quotes fdf' do
        assert_match '<</T(field1)/V[(one)(two)]>>', multi_values_fdf.to_fdf
      end
    end
  end
end
