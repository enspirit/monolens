module Monolens
  class ErrorHandler
    include Enumerable

    def initialize
      @errors = []
    end

    def call(error)
      @errors << error
    end

    def each(&bl)
      @errors.each(&bl)
    end

    def size
      @errors.size
    end

    def empty?
      @errors.empty?
    end

    def report
      @errors
        .map{|err| "[#{err.location.join('/')}] #{err.message}" }
        .join("\n")
    end
  end
end
