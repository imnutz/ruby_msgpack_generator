require "msgpack"
require "zlib"

module MsgpackGenerator
  module Commands
    class Degenerate < BaseCommand
      def run
        input_file = options[:input]

        unpack_msgpack_file(input_file)
      end

      private
      def unpack_msgpack_file(file_name)
        if file_name.match(/\.gz$/)
          File.open(file_name, "r") do |f|
            reader = Zlib::GzipReader.new(f)
            unpacker = MessagePack::Unpacker.new(reader)
            unpacker.each do |obj|
              puts obj
            end
          end
        else
          File.open(file_name, "r") do |f|
            unpacker = MessagePack::Unpacker.new(f)
            unpacker.each do |obj|
              puts obj
            end
          end
        end
      end
    end
  end
end
