require 'spec_helper'

rx = %r{
Applying the following lens:

```yaml
([^`]+)
```

to the following input:

```yaml
([^`]+)
```

will return:

```yaml
([^`]+)
```
}
Path.dir.parent.glob('documentation/*/*.md') do |file|
  describe file do
    if file.read =~ rx
      lens, input, output = $1, $2, $3

      it 'has correct examples' do
        lens = Monolens.lens(YAML.load(lens))
        input = YAML.load(input)
        output = YAML.load(output)
        expect(lens.call(input)).to eql(output)
      end
    else
      puts "WARN: missing or invalid example in #{file}"
    end
  end
end
