module SproutCore
  module Compiler
    autoload :Preprocessors,     "sproutcore/compiler/preprocessors"
    autoload :VirtualFileSystem, "sproutcore/compiler/virtual_file_system"

    class << self
      attr_accessor :intermediate, :output
    end
  end
end
