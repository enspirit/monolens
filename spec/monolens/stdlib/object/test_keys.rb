require 'spec_helper'

describe Monolens, 'object.keys' do
  context 'with string keys' do
    subject do
      Monolens.lens('object.keys' => ['str.upcase'])
    end

    it 'works as expected' do
      input = {
        'firstname' => 'Bernard',
        'lastname' => 'Lambeau'
      }
      expected = {
        'FIRSTNAME' => 'Bernard',
        'LASTNAME' => 'Lambeau'
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'with symbol keys' do
    subject do
      Monolens.lens('object.keys' => ['coerce.string', 'str.upcase'])
    end

    it 'works as expected with Symbol keys' do
      input = {
        firstname: 'Bernard',
        lastname: 'Lambeau'
      }
      expected = {
        FIRSTNAME: 'Bernard',
        LASTNAME: 'Lambeau'
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  describe 'error handling' do
    let(:lens) do
      Monolens.lens('object.keys' => ['str.upcase'])
    end

    subject do
      lens.call(input)
      nil
    rescue Monolens::LensError => ex
      ex
    end

    let(:input) do
      {
        'firstname' => 'Bernard',
        nil => 'Lambeau'
      }
    end

    it 'correctly updates the location' do
      expect(subject.location).to eql([nil])
    end
  end
end
