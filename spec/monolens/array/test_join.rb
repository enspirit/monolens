require 'spec_helper'

describe Monolens, 'array.join' do
  context 'when used without options' do
    subject do
      Monolens.lens('array.join')
    end

    it 'joins values with spaces' do
      expect(subject.call(['hello', 'world'])).to eql('hello world')
    end

    it 'supports empty arrays' do
      expect(subject.call([])).to eql('')
    end
  end

  context 'when specifying the separator' do
    subject do
      Monolens.lens('array.join' => { separator: ', ' })
    end

    it 'joins values with it' do
      expect(subject.call(['hello', 'world'])).to eql('hello, world')
    end
  end
end
