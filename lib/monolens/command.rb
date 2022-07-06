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
      @enclose = []
      @output_format = :json
      @fail_strategy = 'fail'
    end
    attr_reader :argv, :stdin, :stdout, :stderr
    attr_reader :pretty
    attr_reader :enclose_map, :fail_strategy

    def self.call(argv, stdin = $stdin, stdout = $stdout, stderr = $stderr)
      new(argv, stdin, stdout, stderr).call
    end

    def call
      lens, input = options.parse!(argv)
      show_help_and_exit if lens.nil? || input.nil?

      lens_data, input = read_file(lens), read_file(input)
      lens = build_lens(lens_data)
      error_handler = ErrorHandler.new
      result = lens.call(input, error_handler: error_handler)

      unless error_handler.empty?
        stderr.puts(error_handler.report)
      end

      output_result(result) if result
    rescue Monolens::LensError => ex
      stderr.puts("[#{ex.location.join('/')}] #{ex.message}")
      do_exit(-2)
    end

    def read_file(file)
      case ::File.extname(file)
      when /json$/
        content = ::File.read(file)
        JSON.parse(content)
      when /ya?ml$/
        content = ::File.read(file)
        YAML.safe_load(content)
      when /csv$/
        require 'bmg'
        Bmg.csv(file).to_a
      when /xlsx?$/
        require 'bmg'
        Bmg.excel(file).to_a
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
        opts.on('-m', '--map', 'Enclose the loaded lens inside an array.map') do
          @enclose << :map
        end
        opts.on('-l', '--literal', 'Enclose the loaded lens inside core.literal') do
          @enclose << :literal
        end
        opts.on('--on-error=STRATEGY', 'Apply a specific strategy on error') do |strategy|
          @fail_strategy = strategy
        end
        opts.on('-ILIB', 'Add a folder to ruby load path') do |lib|
          $LOAD_PATH.unshift(lib)
        end
        opts.on('-rLIB', 'Add a ruby require of a lib') do |lib|
          require(lib)
        end
        opts.on('-p', '--[no-]pretty', 'Show version and exit') do |pretty|
          @pretty = pretty
        end
        opts.on('-y', '--yaml', 'Print output in YAML') do
          @output_format = :yaml
        end
        opts.on('-j', '--json', 'Print output in JSON') do
          @output_format = :json
        end
      end
    end

    def build_lens(lens_data)
      lens_data = @enclose.inject(lens_data) do |memo, lens_name|
        case lens_name
        when :map
          {
            'array.map' => {
              'on_error' => ['handler', fail_strategy].compact,
              'lenses' => memo,
            }
          }
        when :literal
          {
            'core.literal' => {
              'defn' => memo,
            }
          }
        end
      end
      Monolens.lens(lens_data)
    end

    def output_result(result)
      output = case @output_format
      when :json
        pretty ? JSON.pretty_generate(result) : result.to_json
      when :yaml
        YAML.dump(result)
      end

      stdout.puts output
    end
  end
end
