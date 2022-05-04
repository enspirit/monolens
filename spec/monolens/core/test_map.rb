require 'spec_helper'

describe Monolens, 'map' do
  subject do
    Monolens.lens('map' => ['str.upcase'])
  end

  it 'maps as expected' do
    expect(subject.call(['foo','bar'])).to eql(['FOO','BAR'])
  end
end
