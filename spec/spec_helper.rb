require "rubygems"
require "bundler/setup"
require "fileutils"

require "sproutcore"

RSpec::Core.configure do |config|
  config.before do
    @tmp = File.expand_path("../../tmp", __FILE__)
    FileUtils
  end
end
