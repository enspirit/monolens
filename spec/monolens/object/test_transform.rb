require 'spec_helper'

describe Monolens, 'object.transform' do
  subject do
    Monolens.lens('object.transform' => { firstname: 'str.upcase' })
  end

  it 'works as expected' do
    expect(subject.call(firstname: 'Bernard')).to eql(firstname: 'BERNARD')
  end

  it 'works as expected on an object with String keys' do
    expect(subject.call('firstname' => 'Bernard')).to eql('firstname' => 'BERNARD')
  end
end
