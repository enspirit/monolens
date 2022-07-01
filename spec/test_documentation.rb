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

def yaml_load(input)
  if YAML.respond_to?(:unsafe_load)
    YAML.unsafe_load(input)
  else
    YAML.load(input)
  end
end

Path.dir.parent.glob('documentation/*/*.md') do |file|
  describe file do
    if file.read =~ rx
      lens, input, output = $1, $2, $3

      it 'has correct examples' do
        lens = Monolens.lens(yaml_load(lens))
        input = yaml_load(input)
        output = yaml_load(output)
        expect(lens.call(input)).to eql(output)
      end
    else
      puts "WARN: missing or invalid example in #{file}"
    end
  end
end
