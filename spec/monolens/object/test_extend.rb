require 'spec_helper'

describe Monolens, 'object.extend' do
  subject do
    Monolens.lens('object.extend' => {
      defn: {
        name: [
          { 'core.dig' => { defn: ['firstname'] } },
          'str.upcase'
        ]
      }
    })
  end

  it 'works as expected' do
    input = {
      'firstname' => 'Bernard',
      'lastname' => 'Lambeau'
    }
    expected = input.merge({
      'name' => 'BERNARD',
    })
    expect(subject.call(input)).to eql(expected)
  end

  describe 'on_error' do
    let(:lens) do
      Monolens.lens({
        'array.map' => {
          :lenses => {
            'object.extend' => {
              on_error: on_error,
              defn: {
                upcased: [
                  { 'core.dig' => { defn: ['firstname'] } },
                  'str.upcase'
                ]
              }
            }.compact
          }
        }
      })
    end

    subject do
      lens.call(input)
    rescue Monolens::LensError => ex
      ex
    end

    context 'default' do
      let(:on_error) do
        nil
      end

      let(:input) do
        [{}]
      end

      it 'works as expected' do
        expect(subject).to be_a(Monolens::LensError)
        expect(subject.location).to eql([0, :upcased])
      end
    end

    context 'with :null' do
      let(:on_error) do
        :null
      end

      let(:input) do
        [{}]
      end

      it 'works as expected' do
        expect(subject).to eql([{'upcased' => nil}])
      end
    end

    context 'with :skip' do
      let(:on_error) do
        :skip
      end

      let(:input) do
        [{}]
      end

      it 'works as expected' do
        expect(subject).to eql([{}])
      end
    end
  end
end
