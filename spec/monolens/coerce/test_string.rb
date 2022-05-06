require 'spec_helper'

describe Monolens, 'coerce.string' do
  subject do
    Monolens.lens('coerce.string')
  end

  it 'works' do
    expect(subject.call(12)).to eql('12')
  end

  it 'accepts null' do
    expect(subject.call(nil)).to eql('')
  end
end
