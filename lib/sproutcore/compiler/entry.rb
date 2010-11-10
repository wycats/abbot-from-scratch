module SproutCore
  module Compiler
    class Entry
      attr_reader :name, :body

      def initialize(name, body)
        @name, @body = name, body
        @extension = name.include?(".") && name.split(".").last
      end

      def dependencies
        @dependencies ||= begin
          @body.scan(%r{\b(?:sc_)?require\(['"]([^'"]*)['"]\)}).map do |match|
            dep = match.last

            if !dep.include?(".") && @extension
              dep = [match.last, @extension].join(".")
            end

            dep
          end
        end
      end
    end
  end
end
