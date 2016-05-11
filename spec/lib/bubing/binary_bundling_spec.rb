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
    end

    describe 'run.sh' do
      context 'without envs' do
        it 'should be valid' do
          Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle').bundle!
          expect(IO.read(File.join('.', 'binary_bundle', 'run.sh'))).to eq("#!/bin/bash\nLD_LIBRARY_PATH=./lib ./lib/ld-linux-x86-64.so.2 ./bin/test_project \"$@\"\n")
        end
      end

      context 'with envs' do
        it 'should be valid' do
          Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle', envs: ['TEST=1']).bundle!
          expect(IO.read(File.join('.', 'binary_bundle', 'run.sh'))).to eq("#!/bin/bash\nTEST=1 LD_LIBRARY_PATH=./lib ./lib/ld-linux-x86-64.so.2 ./bin/test_project \"$@\"\n")
        end
      end

      context 'with custom run script name' do
        it 'should be valid' do
          Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle', run_script: 'execute.sh').bundle!
          expect(IO.read(File.join('.', 'binary_bundle', 'execute.sh'))).to eq("#!/bin/bash\nLD_LIBRARY_PATH=./lib ./lib/ld-linux-x86-64.so.2 ./bin/test_project \"$@\"\n")
        end
      end
    end
  end

  context 'with additional ld_path do' do
    it 'should bundle binary and dependencies' do
      Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle', ld_paths: ['/usr/']).bundle!
      expect(File.exist?(File.join('.', 'binary_bundle', 'bin', 'test_project'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libm.so.6'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'ld-linux-x86-64.so.2'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libc.so.6'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libgcc_s.so.1'))).to be_truthy
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libstdc++.so.6'))).to be_truthy
    end
  end

  context 'with plugins' do
    it 'should bundle plugins' do
      Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle', plugins: ['./libltest_project.so']).bundle!
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libltest_project.so'))).to be_truthy
    end
  end

  context 'with plugin_dirs' do
    it 'should bundle plugin dirs' do
      Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle', plugin_dirs: ['/usr/lib/awk']).bundle!
      expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'awk'))).to be_truthy
    end
  end

  context 'with files' do
    it 'should bundle' do
      Bubing::BundlerFactory.new.build(File.expand_path('test_project'), 'binary_bundle', files: ['CMakeCache.txt=test']).bundle!
      expect(File.exist?(File.join('.', 'binary_bundle', 'test', 'CMakeCache.txt'))).to be_truthy
    end
  end
end