describe Monolens, 'object.merge' do
  subject do
    Monolens.lens('object.merge' => {
      priority: priority,
      deep: deep,
      defn: {
        name: 'Monolens',
        version: "1.0",
        links: {
          github: "https://github.com/enspirit/monolens"
        },
      }
    }.compact)
  end

  let(:priority) do
    nil
  end

  let(:deep) do
    nil
  end

  describe 'with default options' do
    it 'works as expected on a flat structure' do
      input = {
        version: "1.2",
        extra: "foo"
      }
      expected = {
        name: 'Monolens',
        version: "1.0",
        links: {
          github: "https://github.com/enspirit/monolens"
        },
        extra: "foo"
      }
      expect(subject.call(input)).to eql(expected)
    end

    it 'does not apply a deep merge' do
      input = {
        links: {
          owner: "https://enspirit.be/"
        },
      }
      expected = {
        name: 'Monolens',
        version: "1.0",
        links: {
          github: "https://github.com/enspirit/monolens"
        }
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  describe 'priority: input' do
    let(:priority) do
      'input'
    end

    it 'reverse the logic on shared keys' do
      input = {
        version: "1.2",
        extra: "foo",
      }
      expected = {
        name: 'Monolens',
        version: "1.2",
        links: {
          github: "https://github.com/enspirit/monolens"
        },
        extra: "foo"
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  describe 'deep: true' do
    let(:deep) do
      true
    end

    it 'applies a deep merge' do
      input = {
        version: "1.2",
        links: {
          owner: "https://enspirit.be/",
          github: "https://github.com/enspirit/monolens/"
        },
      }
      expected = {
        name: 'Monolens',
        version: "1.0",
        links: {
          owner: "https://enspirit.be/",
          github: "https://github.com/enspirit/monolens"
        }
      }
      expect(subject.call(input)).to eql(expected)
    end
  end

  describe 'deep: true, priority: input' do
    let(:deep) do
      true
    end

    let(:priority) do
      'input'
    end

    it 'applies a deep merge' do
      input = {
        version: "1.2",
        links: {
          owner: "https://enspirit.be/",
          github: "https://github.com/enspirit/monolens/"
        },
      }
      expected = {
        name: 'Monolens',
        version: "1.2",
        links: {
          owner: "https://enspirit.be/",
          github: "https://github.com/enspirit/monolens/"
        }
      }
      expect(subject.call(input)).to eql(expected)
    end
  end
end
