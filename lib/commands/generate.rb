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
        fields = options[:fields] || ""

        if !fields.empty?
          fields = fields.split(",")
        end

        create_msgpack_file(number_of_records, fields, output_file, gzip)
      end

      private

      def create_msgpack_file(total, fields = [], file_name, gzip)
        records = []

        (1..total).each do |index|
          record = {}
          if !fields.empty?
            fields.each do |field|
              record[field] = Faker::Lorem.sentence
            end
          else
            record = {
              username: Faker::Internet.username,
              password: Faker::Internet.password,
              domain_name: Faker::Internet.domain_name,
              domain_word: Faker::Internet.domain_word,
              domain_suffix: Faker::Internet.domain_suffix,
              ip_v4_address: Faker::Internet.ip_v4_address,
              private_ip_v4_address: Faker::Internet.private_ip_v4_address,
              ip_v6_address: Faker::Internet.ip_v6_address,
              mac_address: Faker::Internet.mac_address,
              url: Faker::Internet.url,
              user_agent: Faker::Internet.user_agent,
              uuid: Faker::Internet.uuid,
            }
          end

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
