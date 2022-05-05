module Monolens
  module Array
    class Map
      include Lens

      def initialize(arg)
        options, lenses = case arg
        when ::Hash
          opts = arg.dup; opts.delete(:lenses)
          _, ls = fetch_on(:lenses, arg)
          raise ArgumentError, 'Lenses are required' if ls.nil?
          [ opts, ls ]
        else
          [{}, arg]
        end
        super(options)
        @lenses = Monolens.lens(lenses)
      end

      def call(arg, *rest)
        is_enumerable!(arg)

        result = []
        arg.each do |a|
          begin
            result << @lenses.call(a)
          rescue Monolens::Error
            case option(:on_error, :raise).to_sym
            when :raise then raise
            when :null  then result << nil
            when :skip  then nil
            end
          end
        end
        result
      end
    end
  end
end
