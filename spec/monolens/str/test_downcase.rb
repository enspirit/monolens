require 'spec_helper'

describe Monolens, 'str.downcase' do
  subject do
    Monolens.lens('str.downcase')
  end

  it 'converts to lowercase' do
    input = 'FOO'
    expected = 'foo'
    expect(subject.call(input)).to eql(expected)
  end
end
