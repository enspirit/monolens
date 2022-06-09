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
end
