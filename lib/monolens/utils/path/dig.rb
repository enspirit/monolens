module Monolens
  module Utils
    class Path
      class Dig < Path
        def one(input)
          parts = @path
            .gsub(/[.\[\]\(\)]/, ';')
            .split(';')
            .reject{|p| p.nil? || p.empty? || p == '$' }
            .map{|p|
              case p
              when /^'[^']+'$/
                use_symbols?(input) ? p[1...-1].to_sym : p[1...-1]
              when /^\d+$/
                p.to_i
              else
                use_symbols?(input) ? p.to_sym : p
              end
            }

          input.dig(*parts)
        end
      end
    end
  end
end
