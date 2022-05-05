require 'spec_helper'

describe Monolens, 'object.transform' do
  context 'with default options' do
    subject do
      Monolens.lens('object.transform' => {
        defn: { firstname: 'str.upcase' }
      })
    end

    it 'works as expected' do
      expect(subject.call(firstname: 'Bernard')).to eql(firstname: 'BERNARD')
    end

    it 'works as expected on an object with String keys' do
      expect(subject.call('firstname' => 'Bernard')).to eql('firstname' => 'BERNARD')
    end

    it 'raises an error if input object does not have a key' do
      expect {
        subject.call(lastname: 'Lambeau')
      }.to raise_error(Monolens::LensError, /firstname/)
    end
  end

  context 'with on_missing: skip' do
    subject do
      Monolens.lens('object.transform' => {
        on_missing: :skip,
        defn: { firstname: 'str.upcase' }
      })
    end

    it 'works as expected' do
      expect(subject.call(firstname: 'Bernard')).to eql(firstname: 'BERNARD')
    end

    it 'skpis if missing' do
      expect(subject.call(lastname: 'Lambeau')).to eql(lastname: 'Lambeau')
    end
  end

  context 'with on_missing: null' do
    subject do
      Monolens.lens('object.transform' => {
        on_missing: :null,
        defn: { firstname: 'str.upcase' }
      })
    end

    it 'works as expected' do
      expect(subject.call(firstname: 'Bernard')).to eql(firstname: 'BERNARD')
    end

    it 'skpis if missing' do
      expect(subject.call(lastname: 'Lambeau')).to eql(firstname: nil, lastname: 'Lambeau')
    end
  end
end
