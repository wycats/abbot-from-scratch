module SproutCore
  module Compiler
    class Target
      attr_accessor :dependencies, :destination

      def initialize(destination, metadata = {}, &block)
        @destination, @metadata, @block = destination, metadata, block
        @dependencies = []
        @invoker      = Invoker.current

        @invoker.register(destination, self)
      end

      def invoker=(invoker)
        @invoker.unregister(@destination)
        @invoker = invoker
        @invoker.register(@destination, self)
      end

      def add_dependency(dep)
        @dependencies << dep
        @dependencies.uniq!
      end

      def invoke
        @dependencies.each do |dep|
          @invoker.invoke(dep)
        end

        @block.call(@metadata, @destination)
      end
    end
  end
end
