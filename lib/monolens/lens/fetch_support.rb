module Monolens
  module Lens
    module FetchSupport

      def fetch_on(attr, arg, default = nil)
        if arg.key?(attr)
          [ attr, arg[attr] ]
        elsif arg.key?(attr_s = attr.to_s)
          [ attr_s, arg[attr_s] ]
        elsif arg.key?(attr_sym = attr.to_sym)
          [ attr_sym, arg[attr_sym] ]
        elsif default
          [ attr, default ]
        else
          nil
        end
      end

    end
  end
end
