require 'spec_helper'

describe Monolens, 'object.rename' do
  subject do
    Monolens.lens('object.rename' => { lastname: :name })
  end

  it 'works as expected' do
    input = {
      'firstname' => 'Bernard',
      'lastname' => 'Lambeau'
    }
    expected = {
      'firstname' => 'Bernard',
      'name' => 'Lambeau'
    }
    expect(subject.call(input)).to eql(expected)
  end

  it 'works as expected with Symbol keys' do
    input = {
      firstname: 'Bernard',
      lastname: 'Lambeau'
    }
    expected = {
      firstname: 'Bernard',
      name: 'Lambeau'
    }
    expect(subject.call(input)).to eql(expected)
  end
end
