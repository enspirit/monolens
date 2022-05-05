require 'spec_helper'

describe Monolens, 'str.strip' do
  subject do
    Monolens.lens('str.strip')
  end

  it 'strips leading and trailing spaces' do
    input = '   foo  '
    expected = 'foo'
    expect(subject.call(input)).to eql(expected)
  end
end
