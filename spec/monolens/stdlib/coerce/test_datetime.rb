require 'spec_helper'

describe Monolens, 'coerce.datetime' do
  subject do
    Monolens.lens('coerce.datetime' => {
    }.merge(options))
  end

  let(:options) do
    {}
  end

  it 'returns DateTime objects unchanged (idempotency)' do
    input = DateTime.now
    expect(subject.call(input)).to be(input)
  end

  describe 'support for formats' do
    let(:options) do
      { formats: ['%d/%m/%Y %H:%M'] }
    end

    it 'coerces valid date times' do
      expect(subject.call('11/12/2022 17:38')).to eql(DateTime.parse('2022-12-11 17:38'))
    end
  end

  describe 'support for a timezone' do
    let(:options) do
      { parser: timezone }
    end

    let(:now) do
      ::DateTime.now
    end

    let(:timezone) do
      Struct.new(:parse, :strptime).new(1, 2)
    end

    before do
      expect(timezone).to receive(:parse).and_return(now)
    end

    it 'uses it to parse' do
      expect(subject.call('2022-01-01')).to be(now)
    end
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
