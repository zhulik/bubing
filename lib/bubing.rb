require 'bubing/binary_info'
require 'bubing/bundler.rb'
require 'bubing/executable_bundler'
require 'bubing/shared_object_bundler'
require 'bubing/bundler_factory'

module Bubing
  def self.configure
    configuration = Configuration.new
    yield configuration
    configuration
  end

  class Configuration
    def initialize
      @options = {}
      @options[:plugins] = []
      @options[:plugin_dirs] = []
      @options[:files] = {}
      @options[:file_dirs] = {}
      @options[:envs] = {}
      @options[:ld_paths] = []
    end

    def binary(path)
      @binary = File.absolute_path(path)
    end

    def directory(path)
      @directory = File.absolute_path(path)
    end

    def add_plugin(path)
      @options[:plugins] << path
    end

    def add_plugin_dir(path)
      @options[:plugin_dirs] << path
    end

    def add_file(from, to)
      @options[:files][File.expand_path(from)] = to
    end

    def add_file_dir(from, to)
      @options[:file_dirs][File.expand_path(from)] = to
    end

    def add_env(var, val)
      @options[:envs][var] = val
    end

    def add_ld_path(path)
      @options[:ld_paths] << File.expand_path(path)
    end

    def run_script(name)
      @options[:run_script] = name
    end

    def verbose!
      @options[:verbose] = true
    end

    def bundle!
      Bubing::BundlerFactory.new.build(@binary, @directory, **@options).bundle!
    end
  end
end
