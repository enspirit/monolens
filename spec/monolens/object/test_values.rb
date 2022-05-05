require 'spec_helper'

describe Monolens, 'object.values' do
  context 'with default options' do
    subject do
      Monolens.lens('object.values' => ['str.upcase'])
    end

    it 'works as expected' do
      input = {
        firstname: 'Bernard',
        lastname: 'Lambeau'
      }
      expected = {
        firstname: 'BERNARD',
        lastname: 'LAMBEAU'
      }
      expect(subject.call(input)).to eql(expected)
    end

    it 'raises an error on any problem' do
      input = {
        firstname: nil,
        lastname: 'Lambeau'
      }
      expect {
        subject.call(input)
      }.to raise_error(Monolens::LensError)
    end
  end

  context 'with on_error: skip' do
    subject do
      Monolens.lens('object.values' => {
        'on_error' => 'skip',
        'lenses' => ['str.upcase']
      })
    end

    it 'skips key/value when an error occurs' do
      input = {
        firstname: nil,
        lastname: 'Lambeau'
      }
      expected = {
        lastname: 'LAMBEAU'
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'with on_error: null' do
    subject do
      Monolens.lens('object.values' => {
        'on_error' => 'null',
        'lenses' => ['str.upcase']
      })
    end

    it 'uses nil as value' do
      input = {
        firstname: 12,
        lastname: 'Lambeau'
      }
      expected = {
        firstname: nil,
        lastname: 'LAMBEAU'
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'with on_error: keep' do
    subject do
      Monolens.lens('object.values' => {
        'on_error' => 'keep',
        'lenses' => ['str.upcase']
      })
    end

    it 'uses nil as value' do
      input = {
        firstname: 12,
        lastname: 'Lambeau'
      }
      expected = {
        firstname: 12,
        lastname: 'LAMBEAU'
      }
      expect(subject.call(input)).to eql(expected)
    end
  end
end
