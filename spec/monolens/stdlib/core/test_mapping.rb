require 'spec_helper'

describe Monolens, 'core.mapping' do
  let(:mapping) do
    { 'defn' => { 'todo' => 'open' } }
  end

  context 'with default options' do
    subject do
      Monolens.lens('core.mapping' => mapping)
    end

    it 'replaces the value by its mapped' do
      expect(subject.call('todo')).to eql('open')
    end

    it 'raises if not found' do
      expect {
        subject.call('nosuchone')
      }.to raise_error(Monolens::LensError)
    end
  end

  context 'with key_hash option' do
    let(:mapping) do
      {
        'key_hash' => 'str.downcase',
        'defn' => { 'todo' => 'open' }
      }
    end

    subject do
      Monolens.lens('core.mapping' => mapping)
    end

    it 'replaces the value by its mapped' do
      expect(subject.call('todo')).to eql('open')
    end

    it 'uses the key_hash before looking for mapping' do
      expect(subject.call('TODO')).to eql('open')
    end

    it 'raises if not found' do
      expect {
        subject.call('nosuchone')
      }.to raise_error(Monolens::LensError)
    end

    context 'with on_missing: keep' do
      subject do
        Monolens.lens('core.mapping' => mapping.merge('on_missing' => 'keep'))
      end

      it 'keeps it if missing' do
        expect(subject.call('nosuchone')).to eql('nosuchone')
      end

      it 'keeps the original one, not the key_hashed one' do
        expect(subject.call('NOSUCHONE')).to eql('NOSUCHONE')
      end
    end
  end

  context 'on_missing: default' do
    subject do
      Monolens.lens('core.mapping' => mapping.merge('on_missing' => 'default', 'default' => 'foo'))
    end

    it 'replaces the value by its mapped' do
      expect(subject.call('todo')).to eql('open')
    end

    it 'returns the default if not found' do
      expect(subject.call('nosuchone')).to eql('foo')
    end
  end

  context 'on_missing: null' do
    subject do
      Monolens.lens('core.mapping' => mapping.merge('on_missing' => 'null'))
    end

    it 'replaces the value by its mapped' do
      expect(subject.call('todo')).to eql('open')
    end

    it 'returns nil if missing' do
      expect(subject.call('nosuchone')).to eql(nil)
    end
  end

  context 'on_missing: keep' do
    subject do
      Monolens.lens('core.mapping' => mapping.merge('on_missing' => 'keep'))
    end

    it 'replaces the value by its mapped' do
      expect(subject.call('todo')).to eql('open')
    end

    it 'returns nil if missing' do
      expect(subject.call('nosuchone')).to eql('nosuchone')
    end
  end

  context 'on_missing: fallback' do
    subject do
      Monolens.lens('core.mapping' => mapping.merge(
        'on_missing' => 'fallback',
        'fallback' => ->(lens, arg, world) { 'foo' }
      ))
    end

    it 'replaces the value by its mapped' do
      expect(subject.call('todo')).to eql('open')
    end

    it 'returns nil if missing' do
      expect(subject.call('nosuchone')).to eql('foo')
    end
  end

  describe 'error handling' do
    let(:lens) do
      Monolens.lens({
        'array.map' => {
          :lenses => {
            'core.mapping' => mapping.merge('on_missing' => 'fail')
          }
        }
      })
    end

    subject do
      begin
        lens.call(['todo', 'foo'])
        nil
      rescue Monolens::LensError => ex
        ex
      end
    end

    it 'sets the location correctly' do
      expect(subject.location).to eql([1])
    end
  end

  context 'backward compatibility' do
    let(:mapping) do
      { 'values' => { 'todo' => 'open' } }
    end

    context 'with using values instead of defn' do
      subject do
        Monolens.lens('core.mapping' => mapping)
      end

      it 'replaces the value by its mapped' do
        expect(subject.call('todo')).to eql('open')
      end

      it 'raises if not found' do
        expect {
          subject.call('nosuchone')
        }.to raise_error(Monolens::LensError)
      end
    end
  end
end
