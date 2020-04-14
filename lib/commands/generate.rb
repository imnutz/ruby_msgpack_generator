require "msgpack"
require "faker"
require "zlib"

module MsgpackGenerator
  module Commands
    class Generate < BaseCommand
      DEFAULT_TOTAL = 10
      DEFAULT_FILE_NAME = "data"

      def run
        number_of_records = options[:total] || DEFAULT_TOTAL
        output_file = options[:output] || DEFAULT_FILE_NAME
        gzip = options[:gzip] || false

        create_msgpack_file(number_of_records, output_file, gzip)
      end

      private
      def create_msgpack_file(total, file_name, gzip)
        records = []
        (1..total).each do |index|
          record = {
            id: index,
            title: Faker::Lorem.sentence,
            description: Faker::Lorem.paragraph
          }

          records << record
        end

        if gzip
          zip_file_name = "#{file_name}.msgpack.gz"

          File.open(zip_file_name, "w") do |f|
            writer = Zlib::GzipWriter.new(f)
            writer.sync = true
            packer = MessagePack::Packer.new(writer)
            packer.write records
            packer.flush
            writer.flush(Zlib::FINISH)
            writer.close
          end
        else
          File.open("#{file_name}.msgpack", "w") do |f|
            packer = MessagePack::Packer.new(f)
            packer.write records
            packer.flush
          end
        end
      end
    end
  end
end
