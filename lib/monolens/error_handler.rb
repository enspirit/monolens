module Monolens
  class ErrorHandler
    def initialize
      @errors = []
    end

    def call(error)
      @errors << error
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
