require 'spec_helper'

module Monolens
  module Utils
    class Path
      describe Dig do
        def one(path, on)
          Dig.new(path).one(on)
        end

        def interpolate(str, on)
          Path.interpolate(str, on)
        end

        describe 'one' do
          it 'supports simplest expressions' do
            got = one('$.name', { name: 'Monolens' })
            expect(got).to eql('Monolens')
          end

          it 'works with String keys' do
            got = one('$.name', { 'name' => 'Monolens' })
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
      end
    end
  end
end
