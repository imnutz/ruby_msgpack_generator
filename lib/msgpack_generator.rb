require "optparse"
require "ostruct"
require "msgpack_generator/version"

require "commands"

module MsgpackGenerator
  class Application
    COMMAND_MAPPINGS = OpenStruct.new({
      "gen": OpenStruct.new({
        "file": "generate",
        "command": "Generate"
      }),
      "degen": OpenStruct.new({
        "file": "degenerate",
        "command": "Degenerate"
      })
    })

    def initialize
      @optparse = OptionParser.new
      @options = {}

      define_options
    end

    attr_reader :options

    def main(argv = [])
      args = @optparse.parse(argv)

      begin
        command_name = args.shift
        if command_name.nil?
          puts @optparse
          exit(1)
        end

        begin
          command = get_command(command_name)
          command.run
        rescue NameError => name_err
          puts name_err.message
          puts @optparse
        rescue LoadError => load_err
          puts load_err.message
          puts @optparse
        end
      end
    end

    def define_options
      @optparse.banner = "Usage: mpg [command] [options]"
      @optparse.separator ""
      @optparse.separator "Commands:"
      @optparse.separator "gen, degen"
      @optparse.separator ""
      @optparse.separator "Options:"

      @optparse.on("-t", "--total [NUM]", Numeric, "Number of records") do |total|
        options[:total] = total
      end

      @optparse.on("-z", "--gzip [flag]", "Gzip") do |gzip|
        options[:gzip] = true
      end

      @optparse.on("-o", "--output [FILE NAME]", String, "File name") do |file_name|
        options[:output] = file_name
      end

      @optparse.on("-i", "--input [FILE NAME]", String, "File name") do |file_name|
        options[:input] = file_name
      end
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
