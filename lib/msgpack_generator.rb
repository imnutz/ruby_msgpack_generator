require "optparse"
require "ostruct"
require "msgpack_generator/version"

require "commands"

module MsgpackGenerator
  class Application
    COMMAND_MAPPINGS = OpenStruct.new({
      "gen": OpenStruct.new({
        "file": "generate",
        "command": "Generate",
      }),
      "degen": OpenStruct.new({
        "file": "degenerate",
        "command": "Degenerate",
      }),
    })

    def initialize
      @optparse = OptionParser.new
      @options = {}

      define_options
    end

    attr_reader :options

    def main(argv = [])
      args = @optparse.parse(argv)

      command_name = args.shift
      if command_name.nil?
        usage nil
        exit(1)
      end

      begin
        command = get_command(command_name)
        command.run
      rescue
        usage nil
      end
    end

    def define_options
      @optparse.banner = <<EOF
usage: #{File.basename($0)} COMMAND [options]

options:
EOF
      @optparse.summary_indent = "  "
      (class << self; self; end).module_eval do
        define_method(:usage) do |errmsg|
          $stdout.puts @optparse.to_s
          $stdout.puts ""
          $stdout.puts <<EOF
commands:
  gen       # generate message pack data
  degen     # extract data from a .msgpack or .msgpack.gz file

EOF
          return 0
        end
      end

      @optparse.on("-t", "--total [NUM]", Numeric, "Number of records, default is 10") do |total|
        options[:total] = total
      end

      @optparse.on("--gzip", "Gzip") do |gzip|
        options[:gzip] = true
      end

      @optparse.on("-o", "--output FILE_NAME", String, "Output file") do |file_name|
        options[:output] = file_name
      end

      @optparse.on("-i", "--input FILE", String, "Message pack file for extracting data, either .msgpack or .msgpack.gz") do |file_name|
        options[:input] = file_name
      end

      @optparse.on("-f", "--fields FIELDS", String, "Fields to be generated, comma separated") do |fields|
        options[:fields] = fields
      end
      @optparse.on("--version", "show version") {
        $stdout.puts "Message pack generator #{VERSION}"
        exit 0
      }
    end

    def const_name(name)
      COMMAND_MAPPINGS[name]["command"]
    end

    def get_command(name)
      begin
        klass = MsgpackGenerator::Commands.const_get(const_name(name))
      rescue NameError
        begin
          require("commands/#{COMMAND_MAPPINGS[name]["file"]}")
          klass = MsgpackGenerator::Commands.const_get(const_name(name))
        rescue LoadError => ex
          raise(ex)
        end
      end

      klass.new(self)
    end
  end
end
