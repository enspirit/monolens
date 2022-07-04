module Monolens
  class Jsonpath
    def self.one_detect_rx(symbol)
      symbol = "\\" + symbol if symbol == '$'
      %r{^#{symbol}\.[^\s]+$}
    end

    def self.interpolate_detect_rx(symbol)
      symbol = "\\" + symbol if symbol == '$'
      %r{#{symbol}[.(]}
    end

    def self.interpolate_rx(symbol)
      %r{
        #{symbol}
        (
          (\.([a-zA-Z0-9.-_\[\]])+)
        |
          (\([^)]+\))
        )        
      }x.freeze
    end

    INTERPOLATE_RXS = {
      '$' => interpolate_rx("\\" + '$'),
      '<' => interpolate_rx('<'),
    }

    DEFAULT_OPTIONS = {
      root_symbol: '$',
      use_symbols: true,
    }

    def initialize(path, options = {})
      @path = path
      @options = DEFAULT_OPTIONS.merge(options)
      @interpolate_rx = INTERPOLATE_RXS[@options[:root_symbol]]
      raise ArgumentError, "Unknown root symbol #{@options.inspect}" unless @interpolate_rx
    end

    def self.one(path, input, options = {})
      Jsonpath.new(path, options).one(input)
    end

    def self.interpolate(str, input, options = {})
      Jsonpath.new('', options).interpolate(str, input)
    end

    def one(input)
      use_symbols = @options[:use_symbols]

      parts = @path
        .gsub(/[.\[\]\(\)]/, ';')
        .split(';')
        .reject{|p| p.nil? || p.empty? || p == '$' || p == '<' }
        .map{|p|
          case p
          when /^'[^']+'$/
            use_symbols ? p[1...-1].to_sym : p[1...-1]
          when /^\d+$/
            p.to_i
          else
            use_symbols ? p.to_sym : p
          end
        }

      input.dig(*parts)
    end

    def interpolate(str, input)
      str.gsub(@interpolate_rx) do |path|
        Jsonpath.one(path, input, @options)
      end
    end
  end
end
