module MsgpackGenerator
  module Commands
    class BaseCommand
      def initialize(application)
        @options = application.options
      end

      attr_reader :options

      def run
        raise(NotImplementedError)
      end
    end
  end
end
