require 'spec_helper'

describe Monolens, 'coerce.array' do
  subject do
    Monolens.lens('coerce.array')
  end

  it 'works' do
    expect(subject.call(12)).to eql([12])
    expect(subject.call(nil)).to eql([])
    expect(subject.call([12, 13])).to eql([12, 13])
  end
end
