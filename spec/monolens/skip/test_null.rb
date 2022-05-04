require 'spec_helper'

describe Monolens, 'skip.null' do
  context 'when used in a Chain' do
    subject do
      Monolens.lens(['skip.null', 'str.upcase'])
    end

    it 'allows ignoring nil' do
      expect(subject.call(nil)).to eql(nil)
    end

    it 'lets other lenses execute otherwise' do
      expect(subject.call('foo')).to eql('FOO')
    end
  end

  context 'when used in a Map' do
    subject do
      Monolens.lens('map' => ['skip.null', 'str.upcase'])
    end

    it 'maps nils' do
      expect(subject.call([nil, 'foo'])).to eql([nil, 'FOO'])
    end
  end

  context 'when used in a Map, but we want no nils' do
    subject do
      Monolens.lens(['array.compact', { 'map' => ['skip.null', 'str.upcase'] }])
    end

    it 'works' do
      expect(subject.call([nil, 'foo'])).to eql(['FOO'])
    end
  end
end
