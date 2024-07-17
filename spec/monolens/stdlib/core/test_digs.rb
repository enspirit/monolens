require 'spec_helper'

describe Monolens, "core.digs" do
  let(:lens) do
    Monolens.lens('core.digs' => {
      defn: [
        ['foo'],
        ['hobbies', 1, 'name'],
      ]
    })
  end

  it 'works' do
    input = {
      hobbies: [
        { name: 'programming' },
        { name: 'music' }
      ],
      foo: 'Hello'
    }
    expected = ['Hello', 'music']
    expect(lens.call(input)).to eql(expected)
  end

  describe 'error handling' do
    let(:lens) do
      Monolens.lens({
        'array.map' => {
          lenses: {
            'core.digs' => {
              on_missing: on_missing,
              defn: [
                ['foo'],
                ['hobbies', 1, 'name'],
              ]
            }.compact
          }
        }
      })
    end

    subject do
      begin
        lens.call(input)
      rescue Monolens::LensError => ex
        ex
      end
    end

    context 'default behavior' do
      let(:on_missing) do
        nil
      end

      let(:input) do
        [{
          hobbies: [
            { name: 'programming' }
          ]
        }]
      end

      it 'fails as expected' do
        expect(subject).to be_a(Monolens::LensError)
        expect(subject.location).to eql([0])
      end
    end

    context 'on_missing: null' do
      let(:on_missing) do
        :null
      end

      let(:input) do
        [{
          hobbies: [
            { name: 'programming' }
          ]
        }]
      end

      it 'works' do
        expect(subject).to eql([[nil, nil]])
      end
    end
  end
end
