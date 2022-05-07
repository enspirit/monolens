require 'spec_helper'

describe Monolens, 'object.select' do
  context 'when using symbols in the definition' do
    subject do
      Monolens.lens('object.select' => {
        defn: {
          name: [:firstname, :lastname],
          status: :priority
        }
      })
    end

    it 'works as expected' do
      input = {
        firstname: 'Bernard',
        lastname: 'Lambeau',
        priority: 12
      }
      expected = {
        name: ['Bernard', 'Lambeau'],
        status: 12
      }
      expect(subject.call(input)).to eql(expected)
    end

    it 'works as with Strings' do
      input = {
        'firstname' => 'Bernard',
        'lastname' => 'Lambeau',
        'priority' => 12
      }
      expected = {
        'name' => ['Bernard', 'Lambeau'],
        'status' => 12
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'when using strings in the definition' do
    subject do
      Monolens.lens('object.select' => {
        'defn' => {
          'name' => ['firstname', 'lastname'],
          'status' => 'priority'
        }
      })
    end

    it 'works as expected with Symbols' do
      input = {
        firstname: 'Bernard',
        lastname: 'Lambeau',
        priority: 12
      }
      expected = {
        name: ['Bernard', 'Lambeau'],
        status: 12
      }
      expect(subject.call(input)).to eql(expected)
    end

    it 'works with Strings' do
      input = {
        'firstname' => 'Bernard',
        'lastname' => 'Lambeau',
        'priority' => 12
      }
      expected = {
        'name' => ['Bernard', 'Lambeau'],
        'status' => 12
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'when using an array as selection' do
    subject do
      Monolens.lens('object.select' => {
        defn: [
          :firstname,
          :priority
        ]
      })
    end

    it 'works as expected' do
      input = {
        firstname: 'Bernard',
        lastname: 'Lambeau',
        priority: 12
      }
      expected = {
        firstname: 'Bernard',
        priority: 12
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'when a key is missing and no option' do
    subject do
      Monolens.lens('object.select' => {
        defn: {
          name: [:firstname, :lastname],
          status: :priority
        }
      })
    end

    it 'raises an error' do
      input = {
        firstname: 'Bernard'
      }
      expect{
        subject.call(input)
      }.to raise_error(Monolens::LensError, /lastname/)
    end
  end

  context 'when using on_missing: skip' do
    subject do
      Monolens.lens('object.select' => {
        on_missing: :skip,
        defn: {
          name: [:firstname, :lastname],
          status: :priority
        }
      })
    end

    it 'works as expected' do
      input = {
        firstname: 'Bernard'
      }
      expected = {
        name: ['Bernard']
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'when using on_missing: null' do
    subject do
      Monolens.lens('object.select' => {
        on_missing: :null,
        defn: {
          name: [:firstname, :lastname],
          status: :priority
        }
      })
    end

    it 'works as expected' do
      input = {
        firstname: 'Bernard'
      }
      expected = {
        name: ['Bernard', nil],
        status: nil
      }
      expect(subject.call(input)).to eql(expected)
    end

    it 'works as expected' do
      input = {
        priority: 12
      }
      expected = {
        name: [nil, nil],
        status: 12
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  describe 'error traceability' do
    let(:lens) do
      Monolens.lens('object.select' => {
        defn: {
          status: :priority
        }
      })
    end

    subject do
      lens.call(input)
      nil
    rescue Monolens::LensError => ex
      ex
    end

    let(:input) do
      {}
    end

    it 'correctly updates the location' do
      expect(subject.location).to eql([:status])
    end
  end
end
