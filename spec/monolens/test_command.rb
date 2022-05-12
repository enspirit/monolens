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

    subject do
      begin
        command.call
      rescue Exited
      end
    end

    before do
      subject
    end

    def exit_status
      command.exit_status
    end

    def reloaded_json
      JSON.parse(stdout.string)
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