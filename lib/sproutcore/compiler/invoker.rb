require "set"

module SproutCore
  module Compiler
    class Invoker
      def self.current
        @invoker ||= Invoker.new
      end

      def self.current=(current)
        @invoker = current
      end

      def initialize
        @targets = {}
        @invoked = Set.new
      end

      def register(name, dep)
        @targets[name] = dep
      end

      def unregister(name)
        @targets.delete(name)
      end

      def invoke_name(name)
        invoke(@targets[name])
      end

      def invoke(dep)
        return if @invoked.include?(dep.destination)

        @invoked << dep.destination

        dep.invoke
      end
    end
  end
end
