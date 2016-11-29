require "spec_helper"
require "chef/chef_fs/file_system/repository/nodes_dir"
require "chef/chef_fs/file_system/base_fs_object"
require "chef/chef_fs/path_utils"

describe Chef::ChefFS::FileSystem::Repository::NodesDir do
  let(:root) do
    Chef::ChefFS::FileSystem::BaseFSDir.new("", nil)
  end

  let(:tmp_dir) { Dir.mktmpdir }

  let(:test_dir) { Chef::ChefFS::PathUtils.join(tmp_dir, "test") }

  let(:directory) do
    described_class.new("test", root, test_dir)
  end

  let(:file_path) { File.join(directory.file_path, "test") }

  after do
    FileUtils.rm_f(file_path)
  end

  describe "#create" do
    it "creates the directory" do
      directory.create
      expect(File.exists?(directory.file_path)).to be(true)
    end

    it "sets permissions to 700" do
      directory.create
      expect(File.stat(directory.file_path).mode.to_s(8)[2..5]).to eq("700")
    end
  end
end
