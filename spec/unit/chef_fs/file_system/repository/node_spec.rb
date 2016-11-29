require "spec_helper"
require "chef/chef_fs/file_system/repository/node"
require "chef/chef_fs/file_system/repository/nodes_dir"
require "chef/chef_fs/file_system/base_fs_object"

describe Chef::ChefFS::FileSystem::Repository::Node do
  let(:root) do
    Chef::ChefFS::FileSystem::BaseFSDir.new("", nil)
  end

  let(:tmp_dir) { Dir.mktmpdir }

  let(:node_dir) do
    Chef::ChefFS::FileSystem::Repository::NodesDir.new("nodes", root, tmp_dir)
  end

  let(:node) do
    node = described_class.new("node_file.json", node_dir)
    node.write_pretty_json = false
    node
  end

  let(:content) { '"name": "canteloup"' }
  let(:file_path) { File.join(node_dir.file_path, "node_file.json") }

  after do
    FileUtils.rm_f(file_path)
  end

  describe "#create" do
    it "creates the file" do
      node.create(content)
      expect(File.exists?(file_path)).to be(true)
    end

    it "sets permissions to 0600" do
      node.create(content)
      expect(File.stat(file_path).mode.to_s(8)[2..5]).to eq("0600")
    end
  end
end
