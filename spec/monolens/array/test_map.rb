require 'spec_helper'

describe Monolens, 'array.map' do
  context 'without options' do
    subject do
      Monolens.lens('array.map' => 'str.upcase')
    end

    it 'joins values with spaces' do
      input = ['hello', 'world']
      expected = ['HELLO', 'WORLD']
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'skipping on error' do
    subject do
      Monolens.lens('array.map' => {
        on_error: 'skip',
        lenses: [ 'str.upcase' ]
      })
    end

    it 'skips errors' do
      input = [nil, 'world']
      expected = ['WORLD']
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'nulling on error' do
    subject do
      Monolens.lens('array.map' => {
        on_error: 'null',
        lenses: [ 'str.upcase' ]
      })
    end

    it 'skips errors' do
      input = [nil, 'world']
      expected = [nil, 'WORLD']
      expect(subject.call(input)).to eql(expected)
    end
  end
end
