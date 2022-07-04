require 'spec_helper'

describe Monolens, 'coerce.integer' do
  subject do
    Monolens.lens('coerce.integer')
  end

  it 'is idempotent' do
    expect(subject.call(12)).to eql(12)
  end

  it 'coerces valid integers' do
    expect(subject.call('12')).to eql(12)
  end

  describe 'error handling' do
    let(:lens) do
      Monolens.lens({
        'array.map' => {
          :lenses => 'coerce.integer'
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
      ['12sh']
    end

    it 'fails on invalid integers' do
      expect(subject).to be_a(Monolens::LensError)
    end

    it 'properly sets the location' do
      expect(subject.location).to eql([0])
    end
  end
end
