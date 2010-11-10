module SproutCore
  module Compiler
    class CombineTask < Rake::FileTask
      attr_accessor :directory

      # Create a series of Preprocessor tasks for the inputs
      def self.with_input(directory, glob, package_root)
        task = define_task(output_location(directory, package_root))

        task.directory = directory

        Dir[File.join(package_root, glob)].sort.each do |input|
          # Create a new Preprocessor task to convert the raw input into
          # preprocessed output in the intermediate location
          task.prerequisites << Rake::FileTask.new(input, Rake.application)
        end

        [task]
      end

      # This method will get updated over time as more types of inputs
      # result in different outputs
      def self.output_location(input, package_root)
        relative_location = input.sub(%r{^#{Compiler.intermediate}/}, '')
        File.join(Compiler.output, "#{relative_location}.js")
      end

      def execute(*)
        entries = Orderer.new

        @prerequisites.map do |task|
          task_name = task.name.sub(%r{^#{Regexp.escape(directory)}/}, '')
          entries.add Entry.new(task_name, File.read(task.name))
        end

        FileUtils.mkdir_p(File.dirname(@name))

        File.open(@name, "wb") do |file|
          file.puts entries.map(&:body).join("\n")
        end
      end
    end
  end
end
