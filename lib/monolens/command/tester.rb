require 'minitest'
require 'paint'
module Monolens
  class Command
    class Tester
      include Minitest::Assertions

      def initialize(command)
        @command = command
        @nb_tests = 0
        @nb_successes = 0
        @nb_errors = 0
        @nb_failures = 0
        Paint.mode = command.use_paint? ? Paint.detect_mode : 0
      end
      attr_accessor :nb_tests, :nb_successes, :nb_errors, :nb_failures

      def call(lens)
        fail!("No tests found") unless lens.is_a?(File)

        self.nb_tests = lens.examples.size
        details = []
        lens.examples.each_with_index do |example, i|
          test_one(lens, example, i, details)
        end

        stdout.puts("\n")
        stdout.puts("\n") unless details.empty?
        details.each do |message|
          stdout.puts(message)
        end

        success = nb_errors == 0 && nb_failures == 0
        stdout.puts(success ? green(last_sentence) : red(last_sentence))

        do_exit(-3) unless success
      end

    private

      def last_sentence
        sentence = "\n"
        sentence << plural('test', nb_tests) << ". "
        sentence << plural('success', nb_successes) << ", "
        sentence << plural('failure', nb_failures) << ", "
        sentence << plural('error', nb_errors) << "."
      end

      def test_one(lens, example, i, details = [])
        input, output = example[:input], example[:output]
        result = lens.call(input)
        if result == output
          self.nb_successes += 1
          stdout.print(green ".")
        else
          self.nb_failures += 1
          stdout.print(red "F")
          details << "Failure on example #{1+i}:\n#{diff output, result}"
        end
      rescue Monolens::Error => ex
        self.nb_errors += 1
        stdout.print("E")
        details << "Error on example #{1+i}: #{ex.message}"
      end

      def green(s)
        Paint[s, :green]
      end

      def red(s)
        Paint[s, :red]
      end

      def plural(who, nb)
        if nb > 1
          "#{nb} #{who}s"
        else
          "#{nb} #{who}"
        end
      end

      [
        :stdout,
        :stderr,
        :do_exit,
      ].each do |name|
        define_method(name) do |*args, &bl|
          @command.send(name, *args, &bl)
        end
      end

    end
  end
end
