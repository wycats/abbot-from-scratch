require "spec_helper"

describe SproutCore::Compiler::VirtualFileSystem do
  MockTime = Struct.new(:now)

  def write
    @fs.write(file, "hello zoo")
  end

  shared_examples_for "a virtual file system" do
    before do
      @time = MockTime.new
      @time.now = Time.now
      @fs = SproutCore::Compiler::VirtualFileSystem.new(@time)
    end

    it "knows that non-existant files don't exist" do
      @fs.exist?(file).should be_false
    end

    it "can create a new file" do
      write
      @fs.read(file).should == "hello zoo"
    end

    it "knows that existant files exist" do
      write
      @fs.exist?(file).should be_true
    end

    it "knows that deleted files don't exist" do
      write
      @fs.delete(file)
      @fs.exist?(file).should be_false
    end

    it "knows the mtime of newly created files" do
      now = @time.now = Time.now

      write
      @fs.mtime(file).should == now
    end

    it "knows the mtime of updated files" do
      @time.now = Time.now - 100
      write
      now = @time.now = Time.now
      write
      @fs.mtime(file).should == now
    end
  end

  describe "at the root" do
    it_should_behave_like "a virtual file system"

    let(:file) { "/zoo" }
  end

  describe "nested" do
    it_should_behave_like "a virtual file system"

    let(:file) { "/zoo/bar" }
  end

  describe "virtual or real file system" do
    before do
      @fs = SproutCore::Compiler::VirtualOrRealFileSystem.new
    end
  end
end
