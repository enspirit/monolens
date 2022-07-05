module Monolens
  class Error < StandardError
  end
  class TypeError < Error
  end
  class LensError < Error
    def initialize(message, location = [])
      super(message)
      @location = location
    end
    attr_reader :location
  end
end
