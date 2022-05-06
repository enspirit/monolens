require 'spec_helper'

describe Monolens, 'error traceability' do
  context 'on a leaf monolens' do
    let(:lens) do
      Monolens.lens('str.upcase')
    end

    subject do
      begin
        lens.call(nil)
      rescue => ex
        ex
      end
    end

    it 'works as expected' do
      expect(subject).to be_a(Monolens::LensError)
      expect(subject.location).to eql([])
    end
  end

  context 'on array.map' do
    let(:lens) do
      Monolens.lens('array.map' => 'str.upcase')
    end

    subject do
      begin
        lens.call(['foo', nil])
      rescue => ex
        ex
      end
    end

    it 'works as expected' do
      expect(subject).to be_a(Monolens::LensError)
      expect(subject.location).to eql([1])
    end
  end

  context 'on array.map => object.values' do
    let(:lens) do
      Monolens.lens('array.map' => { lenses: { 'object.values' => 'str.upcase' } })
    end

    subject do
      begin
        lens.call([{ hello: 'foo' }, { hello: nil }])
      rescue Monolens::LensError => ex
        ex
      end
    end

    it 'works as expected' do
      expect(subject).to be_a(Monolens::LensError)
      expect(subject.location).to eql([1, :hello])
    end
  end
end
