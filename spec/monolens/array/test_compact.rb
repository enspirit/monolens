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
end
