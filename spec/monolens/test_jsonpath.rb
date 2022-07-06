require 'spec_helper'

module Monolens
  describe Jsonpath do
    def one(path, on)
      Jsonpath.one(path, on, options)
    end

    def interpolate(str, on)
      Jsonpath.interpolate(str, on, options)
    end

    let(:options) do
      {}
    end

    describe 'one' do
      it 'supports the root object' do
        got = one('$', { name: 'Monolens' })
        expect(got).to eql({ name: 'Monolens' })
      end

      it 'supports simplest expressions' do
        got = one('$.name', { name: 'Monolens' })
        expect(got).to eql('Monolens')
      end

      it 'supports sub accesses' do
        got = one('$.lib.name', { lib: { name: 'Monolens' } })
        expect(got).to eql('Monolens')
      end

      it 'supports array accesses' do
        got = one('$[0].name', [{ name: 'Monolens' }])
        expect(got).to eql('Monolens')
      end

      it 'supports quoted object accesses' do
        got = one("$['name']", { name: 'Monolens' })
        expect(got).to eql('Monolens')
      end
    end

    describe 'interpolate' do
      it 'supports simplest expressions' do
        got = interpolate('Hello $.name', { name: 'Monolens' })
        expect(got).to eql('Hello Monolens')
      end

      it 'supports parenthesized expressions' do
        got = interpolate('Hello $(.name)', { name: 'Monolens' })
        expect(got).to eql('Hello Monolens')
      end
    end

    describe 'use_symbols: false' do
      let(:options) do
        { use_symbols: false }
      end

      it 'works with String keys' do
        got = one('$.name', { 'name' => 'Monolens' })
        expect(got).to eql('Monolens')
      end
    end

    describe 'changing the root symbol' do
      let(:options) do
        { root_symbol: '<' }
      end

      it 'one keeps working' do
        got = one('<.name', { name: 'Monolens' })
        expect(got).to eql('Monolens')
      end

      it 'interpolate keeps working' do
        got = interpolate('Hello <.name', { name: 'Monolens' })
        expect(got).to eql('Hello Monolens')
      end

      it 'interpolate keeps supporting parentheses' do
        got = interpolate('Hello <(.name)', { name: 'Monolens' })
        expect(got).to eql('Hello Monolens')
      end
    end
  end
end
