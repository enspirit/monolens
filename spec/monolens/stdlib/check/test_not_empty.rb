require 'spec_helper'

describe Monolens, 'check.notEmpty' do
  subject do
    Monolens.lens('check.notEmpty' => options)
  end

  context 'with default options' do
    let(:options) do
      {}
    end

    it 'works on non empty strings' do
      input = '12'
      expect(subject.call(input)).to be(input)
    end

    it 'works on non empty arrays' do
      input = ['12']
      expect(subject.call(input)).to be(input)
    end

    it 'raises on empty strings' do
      input = ''
      expect {
        subject.call(input)
      }.to raise_error(Monolens::LensError, 'Input may not be empty')
    end

    it 'raises on empty arrays' do
      input = []
      expect {
        subject.call(input)
      }.to raise_error(Monolens::LensError, 'Input may not be empty')
    end
  end

  context 'with a specific error message' do
    let(:options) do
      { message: 'Hello failure!' }
    end

    it 'raises on empty strings' do
      input = ''
      expect {
        subject.call(input)
      }.to raise_error(Monolens::LensError, 'Hello failure!')
    end
  end
end
