require 'spec_helper'

describe "What's said in README" do
  let(:input) {
    JSON.parse(<<~JSON)
      [
        {
          "status": "open",
          "body": " Hello world"
        },
        {
          "status": "closed",
          "body": " Foo bar baz"
        }
      ]
    JSON
  }

  let(:lens) {
    Monolens.load_yaml(<<~YML)
    ---
    version: 1.0
    lenses:
    - map:
      - object.transform:
          status:
          - str.upcase
          body:
          - str.strip
      - object.rename:
          body: description
    YML
  }

  let(:expected) {
    JSON.parse(<<~JSON)
      [
        {
          "status": "OPEN",
          "description": "Hello world"
        },
        {
          "status": "CLOSED",
          "description": "Foo bar baz"
        }
      ]
    JSON
  }

  it 'works' do
    expect(lens.call(input)).to eql(expected)
  end
end
