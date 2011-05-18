module SproutCore
  module Compiler
    # The purpose of this class is to create a sorting algorithm that approximates
    # Ruby's require algorithm.
    #
    # It works by adding entries in the order they were added, but adding
    # dependencies first (also in the order they were specified). Once an entry 
    # has been added, it will not be added again.
    #
    # This allows for "circular" dependencies, where two files both need to
    # exist, but their order doesn't matter. This is a case where neither entry
    # technically depends on the other one, but the full expected functionality
    # requires both entries.
    class Orderer
      include Enumerable

      def initialize
        @entries      = []
        @entry_map    = {}
        @sorted       = []
        @seen         = Set.new
      end

      def add(entry)
        @entries << entry
        @entry_map[entry.name] = entry
      end

      def add_optional(entry)
        @entry_map[entry.name] = entry
      end

      def each
        sort!

        @sorted.each do |item|
          yield item
        end
      end

      def sort!
        @entries.each { |entry| require_entry(entry) }
        @sorted
      end

      def require_entry(entry)
        return if @seen.include?(entry)
        @seen << entry

        entry.dependencies.each do |dep|
          # Temporary hack - eventually support cross-package requires
          next if dep.split("/")[0] != entry.name.split("/")[0]
          raise "No such entry #{dep} in:\n#{@entries.map(&:name).join("\n")}" unless @entry_map.key?(dep)
          require_entry(@entry_map[dep])
        end

        @sorted << entry
      end
    end
  end
end
