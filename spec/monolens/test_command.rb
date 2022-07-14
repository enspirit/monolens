require 'spec_helper'
require 'stringio'
require 'monolens'
require 'monolens/command'

module Monolens
  class Exited < Monolens::Error
  end
  class Command
    attr_reader :exit_status

    def do_exit(status)
      @exit_status = status
      raise Exited
    end
  end
  describe Command do
    FIXTURES = (Path.dir/"command").expand_path

    let(:command) do
      Command.new(argv, stdin, stdout, stderr)
    end

    let(:stdin) do
      StringIO.new
    end

    let(:stdout) do
      StringIO.new
    end

    let(:stderr) do
      StringIO.new
    end

    let(:file_args) do
      [FIXTURES/'map-upcase.lens.yml', FIXTURES/'names.json']
    end

    let(:skip_before) do
      false
    end

    subject do
      begin
        command.call
      rescue Exited
      end
    end

    before do
      next if skip_before

      subject
    end

    def exit_status
      command.exit_status
    end

    def reloaded_json
      JSON.parse(stdout.string)
    end

    def reloaded_yaml
      YAML.load(stdout.string)
    end

    context 'with no option nor args' do
      let(:argv) do
        []
      end

      it 'prints the help and exits' do
        expect(exit_status).to eql(0)
        expect(stdout.string).to match(/monolens/)
      end
    end

    context 'with --version' do
      let(:argv) do
        ['--version']
      end

      it 'prints the version and exits' do
        expect(exit_status).to eql(0)
        expect(stdout.string).to eql("Monolens v#{VERSION} - (c) Enspirit #{Date.today.year}\n")
      end
    end

    context 'with a lens and a json input' do
      let(:argv) do
        file_args
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(reloaded_json).to eql(['BERNARD', 'DAVID'])
      end
    end

    context 'when overriding the input file' do
      let(:argv) do
        ['--override', FIXTURES/'map-upcase.lens.yml', FIXTURES/'overrides.json']
      end

      let(:skip_before) do
        true
      end

      before do
        (FIXTURES/'overrides.json').write((FIXTURES/'names.json').read)
        subject
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(stdout.string).to be_empty
        expect((FIXTURES/'overrides.json').load).to eql(['BERNARD', 'DAVID'])
      end
    end

    context 'with --stdin instead of a file' do
      let(:argv) do
        ['--stdin', FIXTURES/'map-upcase.lens.yml']
      end

      let(:skip_before) do
        true
      end

      before do
        expect(command).to receive(:read_input).and_return((FIXTURES/'names.json').load)
        subject
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(reloaded_json).to eql(['BERNARD', 'DAVID'])
      end
    end

    context 'with --pretty' do
      let(:argv) do
        ['--pretty'] + file_args
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(stdout.string).to match(/^\[\n/)
        expect(reloaded_json).to eql(['BERNARD', 'DAVID'])
      end
    end

    context 'with --json' do
      let(:argv) do
        ['--json'] + file_args
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(reloaded_json).to eql(['BERNARD', 'DAVID'])
      end
    end

    context 'with --yaml' do
      let(:argv) do
        ['--yaml'] + file_args
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(reloaded_yaml).to eql(['BERNARD', 'DAVID'])
      end
    end

    context 'with --yaml and --stream' do
      let(:argv) do
        ['--yaml', '--stream'] + file_args
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(stdout.string.gsub(/\n\.\.\.$/, '')).to eql(<<~YAML)
        --- BERNARD
        --- DAVID
        YAML
      end
    end

    context 'with --json and --stream' do
      let(:argv) do
        ['--json', '--stream'] + file_args
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(stdout.string).to eql(<<~JSON)
        "BERNARD"
        "DAVID"
        JSON
      end
    end

    context 'with --map' do
      let(:argv) do
        ['--map'] + [FIXTURES/'upcase.lens.yml', FIXTURES/'names.json']
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(reloaded_json).to eql(['BERNARD', 'DAVID'])
      end
    end

    context 'with --literal' do
      let(:argv) do
        ['--literal'] + [FIXTURES/'literal.yml', FIXTURES/'names.json']
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(reloaded_json).to eql('Bernard David')
      end
    end

    context 'with --literal --map' do
      let(:argv) do
        ['--literal', '--map'] + [FIXTURES/'literal2.yml', FIXTURES/'names.json']
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(reloaded_json).to eql(['Bernard', 'David'])
      end
    end

    context 'with --paint --test' do
      let(:argv) do
        ['--paint', '--test', FIXTURES/'test-ok.lens.yml']
      end

      it 'works as expected' do
        expect(stdout.string).to match(/1 test. 1 success, 0 failure, 0 error./)
        expect(exit_status).to be_nil
      end
    end

    context 'with --no-paint --test' do
      let(:argv) do
        ['--no-paint', '--test', FIXTURES/'test-ok.lens.yml']
      end

      it 'works as expected' do
        expect(stdout.string).to eql(".\n\n1 test. 1 success, 0 failure, 0 error.\n")
        expect(exit_status).to be_nil
      end
    end

    context 'with --no-paint --test with failures' do
      let(:argv) do
        ['--no-paint', '--test', FIXTURES/'test-ko.lens.yml']
      end

      it 'works as expected' do
        expect(stdout.string).to eql("F.\n\nFailure on example 1:\nExpected: \"Monolens\"\n  Actual: \"MONOLENS\"\n\n2 tests. 1 success, 1 failure, 0 error.\n")
        expect(exit_status).to eql(-3)
      end
    end

    context 'when yielding an error' do
      let(:argv) do
        [FIXTURES/'map-upcase.lens.yml', FIXTURES/'names-with-null.json']
      end

      it 'works as expected' do
        expect(exit_status).to eql(-2)
        expect(stdout.string).to eql('')
        expect(stderr.string).to eql("[1] String expected, got NilClass\n")
      end
    end

    context 'when yielding an error with --on-error=skip' do
      let(:argv) do
        ['--map', '--on-error=skip', FIXTURES/'upcase.lens.yml', FIXTURES/'names-with-null.json']
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(reloaded_json).to eql(['BERNARD', 'DAVID'])
      end
    end

    context 'when yielding an error on a robust lens' do
      let(:argv) do
        [FIXTURES/'robust-map-upcase.lens.yml', FIXTURES/'names-with-null.json']
      end

      it 'works as expected' do
        expect(exit_status).to be_nil
        expect(stdout.string).to eql('["BERNARD","DAVID"]'+"\n")
        expect(stderr.string).to eql("[1] String expected, got NilClass\n")
      end
    end
  end
end
