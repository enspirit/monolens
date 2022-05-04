require 'spec_helper'

describe Monolens, 'skip.null' do
  subject do
    Monolens.lens(['skip.null', 'str.upcase'])
  end

  it 'allows ignoring nil' do
    expect(subject.call(nil)).to eql(nil)
  end

  it 'lets other lenses execute otherwise' do
    expect(subject.call('foo')).to eql('FOO')
  end
end
