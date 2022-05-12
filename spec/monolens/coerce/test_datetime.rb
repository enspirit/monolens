require 'spec_helper'

describe Monolens, 'coerce.datetime' do
  subject do
    Monolens.lens('coerce.datetime' => { formats: ['%d/%m/%Y %H:%M'] })
  end

  it 'returns DateTime objects unchanged (idempotency)' do
    input = DateTime.now
    expect(subject.call(input)).to be(input)
  end

  it 'coerces valid date times' do
    expect(subject.call('11/12/2022 17:38')).to eql(DateTime.parse('2022-12-11 17:38'))
  end

  describe 'error handling' do
    let(:lens) do
      Monolens.lens({
        'array.map' => {
          :lenses => 'coerce.datetime'
        }
      })
    end

    subject do
      begin
        lens.call(input)
        nil
      rescue Monolens::LensError => ex
        ex
      end
    end

    let(:input) do
      ['invalid']
    end

    it 'fails on invalid dates' do
      expect(subject).to be_a(Monolens::LensError)
    end

    it 'properly sets the location' do
      expect(subject.location).to eql([0])
    end
  end
end
