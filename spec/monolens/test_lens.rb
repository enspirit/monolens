require 'spec_helper'

describe Monolens, '.lens' do
  it 'allows building a str.strip lens' do
    expect(Monolens.lens('str.strip')).to be_a(Monolens::Str::Strip)
  end

  it 'allows using a Symbol' do
    expect(Monolens.lens(:'str.strip')).to be_a(Monolens::Str::Strip)
  end

  it 'allows using a hash' do
    expect(Monolens.lens(:"str.strip" => {})).to be_a(Monolens::Str::Strip)
  end

  it 'preserves options' do
    got = Monolens.lens(:"coerce.date" => { formats: ['%Y'] })
    expect(got).to be_a(Monolens::Coerce::Date)
    expect(got.options).to eql({ formats: ['%Y'] })
  end

  it 'allows using an Array, factors a Chain with coercion recursion' do
    got = Monolens.lens(['str.strip', 'str.upcase'])
    expect(got).to be_a(Monolens::Core::Chain)
    expect(got.call('  foo')).to eql('FOO')
  end

  it 'allows using an :transform Hash and factors a Transform lense' do
    got = Monolens.lens(transform: { firstname: ['str.strip'] })
    expect(got).to be_a(Monolens::Core::Transform)
    expect(got.call(firstname: '  foo')).to eql(firstname: 'foo')
  end

  it 'raises an error if the lens namespace is not known' do
    expect {
      Monolens.lens('nosuchone.tp')
    }.to raise_error(Monolens::Error, 'No such lens nosuchone.tp')
  end

  it 'raises an error if the lens is not known' do
    expect {
      Monolens.lens('str.nosuchone')
    }.to raise_error(Monolens::Error, 'No such lens str.nosuchone')
  end

  it 'raises an error if trying to call a non lens' do
    expect {
      Monolens.lens('str.inspect')
    }.to raise_error(Monolens::Error, 'No such lens str.inspect')
  end
end
