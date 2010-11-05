require "spec_helper"
require "rake"

describe "Preprocessing task" do
  include SproutCore::Spec::TmpDir
  include SproutCore::Spec::CLIExecution
  include SproutCore::Compiler

  let(:root) { tmp.join("rake") }
  let(:intermediate) { root.join("tmp/intermediate") }
  let(:output) { root.join("tmp/static") }

  before do
    FileUtils.rm_rf(root)
    FileUtils.mkdir_p(root)
  end

  def file_system(path, &block)
    SproutCore::Spec::DirectoryBuilder.new(tmp.join(path), &block)
  end

  def rakefile(string)
    File.open(root.join("Rakefile"), "w") do |file|
      file.puts string
    end
  end

  describe "preprocessing a single file" do
    before do
      file_system(root) do
        directory "frameworks/runtime" do
          file "core.js" do
            write "// BEGIN: core\nsc_super()\n// END: core\n"
          end
        end
      end

      rakefile <<-RAKE
        require "sproutcore"
        SproutCore::Compiler.intermediate = "#{root}/tmp/intermediate"
        SproutCore::Compiler.output       = "#{root}/tmp/static"
        tasks = SproutCore::Compiler::Preprocessors::JavaScriptTask.with_input "frameworks/runtime/**/*.js", "#{root}"
        task(:default => tasks)
      RAKE
    end

    it "places the preprocessed file in the intermediate location" do
      rake
      intermediate.join("runtime/core.js").read.should == "// BEGIN: core\narguments.callee.base.apply(this,arguments)\n// END: core\n"
    end

    it "only runs the preprocessed file once" do
      rake "--trace"
      out.should =~ %r{intermediate/runtime/core\.js\s*$}
      rake "--trace"
      out.should =~ %r{intermediate/runtime/core\.js \(not_needed\)\s*$}
    end

    describe "multiple files" do
      before do
        file_system(root) do
          directory "frameworks/runtime" do
            file "system.js" do
              write "// BEGIN: system\nsc_super()\n// END: system\n"
            end
          end
        end
      end

      it "places the preprocessed files in the intermediate location" do
        rake
        intermediate.join("runtime/core.js").read.should == "// BEGIN: core\narguments.callee.base.apply(this,arguments)\n// END: core\n"
        intermediate.join("runtime/system.js").read.should == "// BEGIN: system\narguments.callee.base.apply(this,arguments)\n// END: system\n"
      end
    end
  end
end
