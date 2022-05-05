require 'spec_helper'

describe Monolens, 'str.upcase' do
  subject do
    Monolens.lens('str.upcase')
  end

  it 'converts to uppercase' do
    input = 'foo'
    expected = 'FOO'
    expect(subject.call(input)).to eql(expected)
  end
end
