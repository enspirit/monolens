require 'spec_helper'

describe Monolens, 'array.map' do
  subject do
    Monolens.lens('array.map' => 'str.upcase')
  end

  it 'joins values with spaces' do
    input = ['hello', 'world']
    expected = ['HELLO', 'WORLD']
    expect(subject.call(input)).to eql(expected)
  end
end
