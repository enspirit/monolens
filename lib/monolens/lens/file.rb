module Monolens
  module Lens
    class File
      include Lens

      def initialize(info)
        @info = info
      end

      def call(*args, &bl)
        @info[:lenses].call(*args, &bl)
      end

      class << self
        alias :info :new
      end

      def to_info
        @info
      end
    end
  end
end
