require 'spec_helper'

describe Monolens, 'str.split' do
  context 'without options' do
    subject do
      Monolens.lens('str.split')
    end

    it 'splits a string as an array using space separator' do
      input = 'foo bar'
      expected = ['foo', 'bar']
      expect(subject.call(input)).to eql(expected)
    end

    it 'is greedy on spaces and splits on carriage returns and tabs' do
      input = "foo   bar\nbaz\tboz"
      expected = ['foo', 'bar', 'baz', 'boz']
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'when specifying the separator' do
    subject do
      Monolens.lens('str.split' => { separator: ',' })
    end

    it 'uses it' do
      input = 'foo,bar'
      expected = ['foo', 'bar']
      expect(subject.call(input)).to eql(expected)
    end

    it 'does not make whitespace magic' do
      input = "foo, bar"
      expected = ['foo', ' bar']
      expect(subject.call(input)).to eql(expected)
    end
  end
end
