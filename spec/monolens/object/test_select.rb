require 'spec_helper'

describe Monolens, 'object.select' do
  context 'when using symbols in the definition' do
    subject do
      Monolens.lens('object.select' => {
        name: [:firstname, :lastname],
        status: :priority
      })
    end

    it 'works as expected' do
      input = {
        firstname: 'Bernard',
        lastname: 'Lambeau',
        priority: 12
      }
      expected = {
        name: ['Bernard', 'Lambeau'],
        status: 12
      }
      expect(subject.call(input)).to eql(expected)
    end

    it 'works as with Strings' do
      input = {
        'firstname' => 'Bernard',
        'lastname' => 'Lambeau',
        'priority' => 12
      }
      expected = {
        'name' => ['Bernard', 'Lambeau'],
        'status' => 12
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  context 'when using strings in the definition' do
    subject do
      Monolens.lens('object.select' => {
        'name' => ['firstname', 'lastname'],
        'status' => 'priority'
      })
    end

    it 'works as expected with Symbols' do
      input = {
        firstname: 'Bernard',
        lastname: 'Lambeau',
        priority: 12
      }
      expected = {
        name: ['Bernard', 'Lambeau'],
        status: 12
      }
      expect(subject.call(input)).to eql(expected)
    end

    it 'works with Strings' do
      input = {
        'firstname' => 'Bernard',
        'lastname' => 'Lambeau',
        'priority' => 12
      }
      expected = {
        'name' => ['Bernard', 'Lambeau'],
        'status' => 12
      }
      expect(subject.call(input)).to eql(expected)
    end
  end
end
