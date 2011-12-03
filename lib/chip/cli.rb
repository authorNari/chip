module Chip
  class CLI
    def initialize
      @command = Command.new

      @opts = OptionParser.new do |o|
        o.on("-h", "--help") do
          @command.send(:help)
          exit 1
        end

        o.on("-v", "--version") do
          @command.send(:version)
          exit 1
        end

        o.on("-f", "--force") do
          @command.force = true
        end
      end
    end
    attr_reader :command

    def run(args)
      args = parse_args!(args)
      method = args.shift || "help"
      @command.send(method, *args)
    rescue ArgumentError
      @command.send(:help)
    rescue InstallError => ex
      puts ex.message
    end

    private
    def parse_args!(args)
      nonopts = []

      begin
        @opts.order!(args) do |nonopt|
          nonopts << nonopt
        end
      rescue OptionParser::InvalidOption => e
        nonopts << e.args.first
        retry
      rescue OptionParser::MissingArgument
        @command.send(:help)
        return
      end

      nonopts + args
    end
  end
end
