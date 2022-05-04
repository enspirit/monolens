require 'spec_helper'

describe Monolens, 'object.keys' do
  subject do
    Monolens.lens('object.keys' => ['str.upcase'])
  end

  it 'works as expected' do
    input = {
      'firstname' => 'Bernard',
      'lastname' => 'Lambeau'
    }
    expected = {
      'FIRSTNAME' => 'Bernard',
      'LASTNAME' => 'Lambeau'
    }
    expect(subject.call(input)).to eql(expected)
  end

  it 'works as expected with Symbol keys' do
    input = {
      firstname: 'Bernard',
      lastname: 'Lambeau'
    }
    expected = {
      FIRSTNAME: 'Bernard',
      LASTNAME: 'Lambeau'
    }
    expect(subject.call(input)).to eql(expected)
  end
end
