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

  context 'on transform.yml' do
    let(:file){ Path.dir/'fixtures/transform.yml' }

    it 'works' do
      input = {
        firstname: 'Bernard',
        lastname: 'Lambeau'
      }
      expected = {
        firstname: 'BERNARD',
        lastname: 'lambeau'
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'on coerce.yml' do
    let(:file){ Path.dir/'fixtures/coerce.yml' }

    it 'works' do
      input = {
        at: '04/05/2022',
      }
      expected = {
        at: Date.parse('2022-05-04')
      }
      expect(subject.call(input)).to eql(expected)
    end
  end
end
