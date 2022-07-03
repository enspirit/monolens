require 'spec_helper'

describe Monolens, "core.literal" do
  let(:lens) do
    Monolens.lens('core.literal' => { defn: 'hello' })
  end

  it 'works' do
    input = {}
    expected = 'hello'
    expect(lens.call(input)).to eql(expected)
  end

  context 'with a simple json path expressions' do
    let(:lens) do
      Monolens.lens('core.literal' => { defn: '$.foo' })
    end

    it 'works' do
      input = { 'foo' => 'bar' }
      expected = 'bar'
      expect(lens.call(input)).to eql(expected)
    end

    it 'works with symbols too' do
      input = { foo: 'bar' }
      expected = 'bar'
      expect(lens.call(input)).to eql(expected)
    end
  end

  context 'with an object literal with json path expressions' do
    let(:lens) do
      Monolens.lens('core.literal' => {
        defn: {
          hobbies: [{
            name: '$.foo'
          }]
        }
      })
    end

    it 'works' do
      input = { 'foo' => 'bar' }
      expected = { hobbies: [{ name: 'bar' }] }
      expect(lens.call(input)).to eql(expected)
    end

    it 'works with symbols too' do
      input = { foo: 'bar' }
      expected = { hobbies: [{ name: 'bar' }] }
      expect(lens.call(input)).to eql(expected)
    end
  end
end
