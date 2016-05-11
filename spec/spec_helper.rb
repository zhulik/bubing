require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
])
SimpleCov.start
require 'bubing'

$LOAD_PATH << '../lib'

RSpec.configure do |config|
  config.order = 'random'

  config.before(:all) do
    Dir.chdir('spec/fixtures/test_project') do
      FileUtils.rm_rf('build')
      FileUtils.mkdir('build')
      Dir.chdir('build') do
        FileUtils.mkdir('binary_bundle')
        FileUtils.mkdir('library_bundle')
        `cmake ..`
        `make`
      end
    end
  end

  config.around(:each) do |example|
    Dir.chdir('spec/fixtures/test_project/build') do
      example.run
    end
  end
end