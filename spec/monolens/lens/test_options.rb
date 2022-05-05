require 'spec_helper'

module Monolens
  module Lens
    describe Options do
      subject do
        Options.new(input)
      end

      describe 'initialize' do
        context('when used with a Hash') do
          let(:input) do
            { separator: ',' }
          end

          it 'uses a copy of the hash' do
            expect(subject.send(:options)).not_to be(input)
            expect(subject.to_h).not_to be(input)
            expect(subject.to_h).to eql(input)
          end
        end

        context('when used with an Array') do
          let(:input) do
            ['str.strip']
          end

          it 'converts it to lenses' do
            expect(subject.to_h.keys).to eql([:lenses])
            lenses = subject.to_h[:lenses]
            expect(lenses).to be_a(Core::Chain)
          end
        end

        context('when used with a String') do
          let(:input) do
            'str.strip'
          end

          it 'converts it to lenses' do
            expect(subject.to_h.keys).to eql([:lenses])
            lenses = subject.to_h[:lenses]
            expect(lenses).to be_a(Str::Strip)
          end
        end
      end

      describe 'fetch' do
        context 'when used with Symbols' do
          let(:input) do
            { separator: ',' }
          end

          it 'lets fetch as Symbols' do
            expect(subject.fetch(:separator)).to eql(',')
          end

          it 'lets fetch as Strings' do
            expect(subject.fetch('separator')).to eql(',')
          end

          it 'raises if not found' do
            expect { subject.fetch('nosuchone') }.to raise_error(Monolens::Error)
          end

          it 'lets pass a default value' do
            expect(subject.fetch('nosuchone', 'foo')).to eql('foo')
          end
        end
      end
    end
  end
end
