require 'spec_helper'

module Monolens
  module Lens
    describe Signature do
      let(:signature) do
        Signature.new(Type::String, Type::String, {
          separator: [Type::String, true],
          help: [Type::String, false]
        })
      end

      it 'is ok with valid options' do
        expect {
          signature.dress_options({ separator: ',' }, nil)
        }.not_to raise_error
      end

      it 'detects a missing option' do
        expect {
          signature.dress_options({}, nil)
        }.to raise_error(Error, /Missing option `separator`/)
      end

      it 'detects an extra option' do
        expect {
          signature.dress_options({ foo: 'bar' }, nil)
        }.to raise_error(Error, /Invalid option `foo`/)
      end

      it 'detects an option of the wrong type' do
        expect {
          signature.dress_options({ separator: 12 }, nil)
        }.to raise_error(Error, /Invalid option `separator`: Invalid string 12/)
      end
    end
  end
end
