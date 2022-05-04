require 'spec_helper'

describe Monolens, 'object.values' do
  subject do
    Monolens.lens('object.values' => ['str.upcase'])
  end

  it 'works as expected' do
    input = {
      firstname: 'Bernard',
      lastname: 'Lambeau'
    }
    expected = {
      firstname: 'BERNARD',
      lastname: 'LAMBEAU'
    }
    expect(subject.call(input)).to eql(expected)
  end
end
