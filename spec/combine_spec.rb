require "spec_helper"

describe "combining" do
  describe "without requires" do
    before do
      file_system(intermediate) do
        directory "runtime" do
          file "core.js", "// BEGIN: core.js\n// END: core.js\n"

          directory "system" do
            file "binding.js",    "// BEGIN: system/binding.js\n// END: system/binding.js\n"
            file "enumerator.js", "// BEGIN: system/enumerator.js\n// END: system/enumerator.js\n"
          end
        end
      end
    end

    it "combines the files" do
      rakefile_tasks %{SproutCore::Compiler::CombineTask.with_input File.expand_path("tmp/intermediate/runtime"), "**/*.js", SproutCore::Compiler.intermediate}
      rake

      expected = %w(core.js system/binding.js system/enumerator.js).map do |file|
        File.read(intermediate.join("runtime/#{file}"))
      end
      output.join("runtime.js").read.should == expected.join("\n")
    end

    it "orders files based on their contents" do
      file_system(intermediate) do
        directory "runtime" do
          directory "system" do
            file "apple.js",      "require('runtime/system/enumerator')\n// BEGIN: system/apple.js\nEND: system/apple.js"
            file "binding.js",    "// BEGIN: system/binding.js\n// END: system/binding.js\n"
            file "enumerator.js", "// BEGIN: system/enumerator.js\n// END: system/enumerator.js\n"
          end
        end
      end

      rakefile_tasks %{SproutCore::Compiler::CombineTask.with_input File.expand_path("tmp/intermediate/runtime"), "**/*.js", SproutCore::Compiler.intermediate}
      rake

      expected = %w(core.js system/enumerator.js system/apple.js system/binding.js).map do |file|
        File.read(intermediate.join("runtime/#{file}"))
      end
      output.join("runtime.js").read.should == expected.join("\n")
    end
  end
end
