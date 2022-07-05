require 'spec_helper'

describe Monolens, 'array.compact' do
  subject do
    Monolens.lens('array.compact')
  end

  it 'removes nils' do
    expect(subject.call([nil, 'notnil'])).to eql(['notnil'])
  end

  it 'supports empty arrays' do
    expect(subject.call([])).to eql([])
  end

  describe 'signature checking' do
    it 'detects unexisting options' do
      expect {
        Monolens.lens('array.compact' => { foo: 'bar' })
      }.to raise_error(Monolens::Error, /Invalid option `foo`/)
    end
  end
end
