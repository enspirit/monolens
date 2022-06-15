require 'spec_helper'

describe Monolens, 'array.map' do
  context 'without options' do
    subject do
      Monolens.lens('array.map' => 'str.upcase')
    end

    it 'joins values with spaces' do
      input = ['hello', 'world']
      expected = ['HELLO', 'WORLD']
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'default on error' do
    subject do
      Monolens.lens('array.map' => {
        lenses: [ 'str.upcase' ]
      })
    end

    it 'raise errors' do
      input = [nil, 'world']
      expect {
        subject.call(input)
      }.to raise_error(Monolens::LensError)
    end
  end

  context 'skipping on error' do
    subject do
      Monolens.lens('array.map' => {
        on_error: 'skip',
        lenses: [ 'str.upcase' ]
      })
    end

    it 'skips errors' do
      input = [nil, 'world']
      expected = ['WORLD']
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'nulling on error' do
    subject do
      Monolens.lens('array.map' => {
        on_error: 'null',
        lenses: [ 'str.upcase' ]
      })
    end

    it 'skips errors' do
      input = [nil, 'world']
      expected = [nil, 'WORLD']
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'keeping on error' do
    subject do
      Monolens.lens('array.map' => {
        on_error: 'keep',
        lenses: [ 'str.upcase' ]
      })
    end

    it 'skips errors' do
      input = [12, 'world']
      expected = [12, 'WORLD']
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'on error with :handler' do
    subject do
      Monolens.lens('array.map' => {
        on_error: 'handler',
        lenses: [ 'str.upcase' ]
      })
    end

    it 'collects the error then skips' do
      input = [nil, 'world']
      expected = ['WORLD']
      errs = []
      got = subject.call(input, error_handler: ->(err){ errs << err })
      expect(errs.size).to eql(1)
      expect(got).to eql(expected)
    end
  end

  context 'collecting on error then nulling' do
    subject do
      Monolens.lens('array.map' => {
        on_error: ['handler', 'null'],
        lenses: [ 'str.upcase' ]
      })
    end

    it 'uses the handler' do
      input = [nil, 'world']
      expected = [nil, 'WORLD']
      errs = []
      got = subject.call(input, error_handler: ->(err){ errs << err })
      expect(errs.size).to eql(1)
      expect(got).to eql(expected)
    end
  end
end
