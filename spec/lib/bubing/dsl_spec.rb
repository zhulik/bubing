require 'spec_helper'

describe Bubing do
  let!(:interpreter) { Bubing::BinaryInfo.new(File.expand_path('test_project')).interpreter }
  let!(:interpreter_name) { File.basename(interpreter) }

  it 'creates valid bundle through dsl' do
    Bubing::configure do |c|
      c.binary 'test_project'
      c.directory 'binary_bundle'
      c.add_plugin File.expand_path(File.join('.', 'libltest_project.so'))
      c.add_plugin_dir File.join('', 'usr', 'lib', 'awk')
      c.add_file 'CMakeCache.txt', 'test'
      c.add_file_dir(File.join('', 'usr', 'lib', 'awk'), 'test')
      c.add_env('TEST', '1')
      c.add_ld_path(File.join('usr', 'lib'))
      c.run_script('execute.sh')
      c.verbose!
    end.bundle!

    expect(File.exist?(File.join('.', 'binary_bundle', 'bin', 'test_project'))).to be_truthy
    expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libm.so.6'))).to be_truthy
    expect(File.exist?(File.join('.', 'binary_bundle', 'lib', interpreter_name))).to be_truthy
    expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libc.so.6'))).to be_truthy
    expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libgcc_s.so.1'))).to be_truthy
    expect(File.exist?(File.join('.', 'binary_bundle', 'lib', 'libstdc++.so.6'))).to be_truthy
    expect(IO.read(File.join('.', 'binary_bundle', 'execute.sh'))).to eq("#!/bin/bash\nTEST=1 LD_LIBRARY_PATH=./lib ./lib/#{interpreter_name} ./bin/test_project \"$@\"\n")
  end
end