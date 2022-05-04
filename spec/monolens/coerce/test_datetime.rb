require 'spec_helper'

describe Monolens, 'coerce.datetime' do
  subject do
    Monolens.lens('coerce.datetime' => { formats: ['%d/%m/%Y %H:%M'] })
  end

  it 'coerces valid date times' do
    expect(subject.call('11/12/2022 17:38')).to eql(DateTime.parse('2022-12-11 17:38'))
  end

  it 'fails on invalid dates' do
    expect {
      subject.call('invalid')
    }.to raise_error(Monolens::LensError)
  end
end
