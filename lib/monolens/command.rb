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
      @stream = false
      @fail_strategy = 'fail'
      @override = false
      @execute_tests = false
      #
      @input_file = nil
      @use_stdin = false
      #
      @use_paint = true
    end
    attr_reader :argv, :stdin, :stdout, :stderr
    attr_reader :pretty, :stream, :override
    attr_reader :enclose_map, :fail_strategy
    attr_reader :input_file, :use_stdin
    attr_reader :use_paint
    alias :use_paint? :use_paint
    attr_reader :execute_tests
    alias :execute_tests? :execute_tests

    def self.call(argv, stdin = $stdin, stdout = $stdout, stderr = $stderr)
      new(argv, stdin, stdout, stderr).call
    end

    def call
      lens, @input_file = options.parse!(argv)
      show_help_and_exit if lens.nil? || (@input_file.nil? && !use_stdin && !execute_tests?)

      lens = build_lens(read_file(lens))
      if execute_tests?
        execute_tests!(lens)
      else
        input = read_input
        error_handler = ErrorHandler.new
        result = lens.call(input, error_handler: error_handler)

        unless error_handler.empty?
          stderr.puts(error_handler.report)
        end

        output_result(result) if result
      end
    rescue Monolens::LensError => ex
      stderr.puts("[#{ex.location.join('/')}] #{ex.message}")
      do_exit(1)
    end

    def execute_tests!(lens)
      require_relative 'command/tester'
      Tester.new(self).call(lens)
    end

    def read_input
      if use_stdin
        JSON.parse(stdin.read)
      else
        read_file(@input_file)
      end
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
        opts.on( '--stdin', 'Takes input data from STDIN') do
          @use_stdin = true
        end
        opts.on('-p', '--[no-]pretty', 'Show version and exit') do |pretty|
          @pretty = pretty
        end
        opts.on('-y', '--yaml', 'Print output in YAML') do
          @output_format = :yaml
        end
        opts.on('-s', '--stream', 'Stream mode: output each result item separately') do
          @stream = true
        end
        opts.on('-j', '--json', 'Print output in JSON') do
          @output_format = :json
        end
        opts.on('--override', 'Write output back to the input file') do
          @override = true
        end
        opts.on('--test', 'Execute tests embedded in the lens file') do
          @execute_tests = true
        end
        opts.on('--[no-]paint', 'Do (not) paint error messages') do |flag|
          @use_paint = flag
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
      with_output_io do |io|
        output = case @output_format
        when :json
          output_json(result, io)
        when :yaml
          output_yaml(result, io)
        end
      end
    end

    def with_output_io(&block)
      if override
        ::File.open(@input_file, 'w', &block)
      else
        block.call(stdout)
      end
    end

    def output_json(result, io)
      method = pretty ? :pretty_generate : :generate
      if stream
        fail!("Stream mode only works with an output Array") unless result.is_a?(::Enumerable)
        result.each do |item|
          io.puts JSON.send(method, item)
        end
      else
        io.puts JSON.send(method, result)
      end
    end

    def output_yaml(result, io)
      output = stream ? YAML.dump_stream(*result) : YAML.dump(result)
      io.puts output
    end
  end
end
