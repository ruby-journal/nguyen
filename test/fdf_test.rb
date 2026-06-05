require 'test_helper'

describe Nguyen::Fdf do
  describe '#to_fdf' do
    let(:fdf) { Nguyen::Fdf.new field1: 'fieldvalue1', other_field: 'some other value' }

    it 'generates fdf' do
      assert fdf_text = fdf.to_fdf
      assert_includes fdf_text, "<<\n/T(field1)\n/V (fieldvalue1)\n>>"
      assert_includes fdf_text, "<<\n/T(other_field)\n/V (some other value)\n>>"
    end

    describe 'hash value has quotes' do
      let(:quote_fdf) { Nguyen::Fdf.new field1: 'field(va)lue1' }
      it 'generates correct escaped quotes fdf' do
        assert_includes quote_fdf.to_fdf, "<<\n/T(field1)\n/V (field\\(va\\)lue1)\n>>"
      end
    end

    describe 'hash value has multiple values' do
      let(:multi_values_fdf) { Nguyen::Fdf.new field1: %w(one two) }
      it 'generates correct escaped quotes fdf' do
        assert_includes multi_values_fdf.to_fdf, "<<\n/T(field1)\n/V [(one)(two)]\n>>"
      end
    end

    describe 'hash value is boolean' do
      let(:boolean_fdf) { Nguyen::Fdf.new checked_box: true, unchecked_box: false }
      it 'generates checkbox on/off states' do
        fdf_text = boolean_fdf.to_fdf
        assert_includes fdf_text, "<<\n/T(checked_box)\n/V /1\n>>"
        assert_includes fdf_text, "<<\n/T(unchecked_box)\n/V /0\n>>"
      end
    end
  end
end
