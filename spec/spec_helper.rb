require "rubygems"
require "bundler/setup"
require "fileutils"

require "sproutcore"
require "support/builders"
require "support/cli"

module SproutCore
  module Spec
    module TmpDir
      def self.included(klass)
        klass.class_eval do
          let(:tmp) { Pathname.new(File.expand_path("../../tmp", __FILE__)) }

          before do
            FileUtils.rm_rf(tmp)
            FileUtils.mkdir_p(tmp)
          end
        end
      end
    end
  end
end
