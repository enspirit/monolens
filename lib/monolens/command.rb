require 'optparse'
require 'date'
require 'json'
require 'yaml'

module Monolens
  class Command
    def initialize(argv, stdin, stdout, stderr)
      @argv = argv
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
      @pretty = false
    end
    attr_reader :argv, :stdin, :stdout, :stderr
    attr_reader :pretty

    def self.call(argv, stdin = $stdin, stdout = $stdout, stderr = $stderr)
      new(argv, stdin, stdout, stderr).call
    end

    def call
      lens, input = options.parse!(argv)
      show_help_and_exit if lens.nil? || input.nil?

      lens, input = read_file(lens), read_file(input)
      error_handler = ErrorHandler.new
      lens = Monolens.lens(lens)
      result = lens.call(input, error_handler: error_handler)

      unless error_handler.empty?
        stderr.puts(error_handler.report)
      end

      if result
        output = if pretty
          JSON.pretty_generate(result)
        else
          result.to_json
        end

        stdout.puts output
      end
    rescue Monolens::LensError => ex
      stderr.puts("[#{ex.location.join('/')}] #{ex.message}")
      do_exit(-2)
    end

    def read_file(file)
      content = ::File.read(file)
      case ::File.extname(file)
      when /json$/ then JSON.parse(content)
      when /ya?ml$/ then YAML.safe_load(content)
      else
        fail!("Unable to use #{file}")
      end
    end

    def fail!(msg)
      stderr.puts(msg)
      do_exit(1)
    end

    def do_exit(status)
      exit(status)
    end

    def show_help_and_exit
      stdout.puts options
      do_exit(0)
    end

    def options
      @options ||= OptionParser.new do |opts|
        opts.banner = 'Usage: monolens [options] LENS INPUT'

        opts.on('--version', 'Show version and exit') do
          stdout.puts "Monolens v#{VERSION} - (c) Enspirit #{Date.today.year}"
          do_exit(0)
        end
        opts.on('-p', '--[no-]pretty', 'Show version and exit') do |pretty|
          @pretty = pretty
        end
      end
    end
  end
end
