require 'spec_helper'

describe Monolens, 'object.allbut' do
  subject do
    Monolens.lens('object.allbut' => { defn: [ :lastname, :city ] })
  end

  it 'works as expected' do
    input = {
      'firstname' => 'Bernard',
      'lastname' => 'Lambeau',
      'city' => 'Brussels'
    }
    expected = {
      'firstname' => 'Bernard',
    }
    expect(subject.call(input)).to eql(expected)
  end

  it 'works as expected with Symbol keys' do
    input = {
      firstname: 'Bernard',
      lastname: 'Lambeau',
      city: 'Brussels'
    }
    expected = {
      firstname: 'Bernard',
    }
    expect(subject.call(input)).to eql(expected)
  end
end
