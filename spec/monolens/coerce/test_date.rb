require 'spec_helper'

describe Monolens, 'coerce.date' do
  subject do
    Monolens.lens('coerce.date' => { formats: ['%d/%m/%Y'] })
  end

  it 'coerces valid dates' do
    expect(subject.call('11/12/2022')).to eql(Date.parse('2022-12-11'))
  end

  it 'fails on invalid dates' do
    expect {
      subject.call('invalid')
    }.to raise_error(Monolens::LensError)
  end
end
