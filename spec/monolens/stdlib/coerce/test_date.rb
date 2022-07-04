require 'spec_helper'

describe Monolens, 'coerce.date' do
  subject do
    Monolens.lens('coerce.date' => { formats: ['%d/%m/%Y'] })
  end

  it 'returns Date objects unchanged (idempotency)' do
    input = Date.today
    expect(subject.call(input)).to be(input)
  end

  it 'coerces valid dates' do
    expect(subject.call('11/12/2022')).to eql(Date.parse('2022-12-11'))
  end

  describe 'error handling' do
    let(:lens) do
      Monolens.lens({
        'array.map' => {
          :lenses => 'coerce.date'
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
