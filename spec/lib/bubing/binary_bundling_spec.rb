require 'spec_helper'

describe Bubing::Bundler do
  context 'without plugins and files' do
    it 'should bundle binary and dependencies' do
      Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle').bundle!
      expect(File.exist?(File.join('.', 'binary_bundle', 'bin', 'test_project'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libm.so.6'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'ld-linux-x86-64.so.2'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libc.so.6'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libgcc_s.so.1'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libstdc++.so.6'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'run.sh'))).to be_truthy
    end
  end

  context 'with plugins' do
    it 'should bundle' do
      Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle', plugins: ['/usr/lib/libssh2.so']).bundle!
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libssh2.so'))).to be_truthy
    end
  end

  context 'with plugin_dirs' do
    it 'should bundle' do
      Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle', plugin_dirs: ['/usr/lib/awk']).bundle!
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'awk'))).to be_truthy
    end
  end
end