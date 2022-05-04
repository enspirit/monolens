require 'spec_helper'

describe Monolens do

  subject {
    Monolens.load_file(file)
  }

  context 'on simple.yml' do
    let(:file){ Path.dir/'fixtures/simple.yml' }

    it 'works' do
      expect(subject.call(' foo  ')).to eql('FOO')
    end
  end
end
