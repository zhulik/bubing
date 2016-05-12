require 'fileutils'

module Bubing
  class DependencyNotFoundError < StandardError
  end

  class BundlingError < StandardError
  end

  class Bundler
    PATH_RE = /=> (.+?(?=\())/

    def initialize(binary, directory, **options)
      @binary = binary
      @directory = directory
      @interpreter = options[:interpreter]
      @plugins = options[:plugins] || []
      @plugin_dirs = options[:plugin_dirs]  || []
      @files = options[:files]  || []
      @file_dirs = options[:file_dirs]  || []
      @ld_paths = options[:ld_paths] || []
      @verbose = options[:verbose]

      @lib_dir = File.join(directory, 'lib')
      @copied = []
    end

    def bundle!
      prepare_dir
      log("Interpreter is #{@interpreter}")
      copy_deps(@binary)
      log('Copying plugins...')
      log("Plugins to bundle #{@plugins.count}")
      copy_plugins(@plugins)
      log("Plugin dirs to bundle #{@plugin_dirs.count}")
      copy_plugin_dirs
      log('Copying files...')
      log("Files to bundle #{@files.count}")
      copy_files(@files)
      log("File dirs to bundle #{@file_dirs.count}")
      copy_files(@file_dirs)
    rescue Bubing::DependencyNotFoundError => e
      puts "#{e.message} not found!"
      raise Bubing::BundlingError
    end

    protected

    def prepare_dir
      FileUtils.rm_rf(Dir.glob(File.join(@directory, '*')))
      FileUtils.mkdir_p(@directory)
      FileUtils.mkdir_p(@lib_dir)
    end

    def log(message)
      puts message if @verbose
    end

    def extract_path(lib)
      if lib.include?('not found')
        raise DependencyNotFoundError.new(lib.split('=>')[0].strip)
      end
      PATH_RE.match(lib)[1].strip
    end

    def get_deps(file)
      ld_lib_path = if @ld_paths.any?
                      "LD_LIBRARY_PATH=#{@ld_paths.join(':')}"
                    else
                      ''
                    end
      trace = `#{ld_lib_path} LD_TRACE_LOADED_OBJECTS=1 #{@interpreter} #{file}`
      trace.split("\n").map(&:strip).select{|row| row.include?('=>')}.map{|dep| extract_path(dep)}.reject(&:empty?)
    end

    def copy_deps(binary)
      log("Bundling #{binary}")
      deps = get_deps(binary)
      log("#{deps.count} dependencies found: #{deps}")
      copy(deps, @lib_dir)
    end

    def copy(files, dst)
      files = [files].flatten.select{|f| !@copied.include?(f)}
      FileUtils.cp_r(files, dst)
      @copied += files
      @copied.flatten
    end

    def copy_plugins(plugins)
      plugins.each do |plugin|
        copy(plugin, @lib_dir)
        copy_deps(plugin)
      end
    end

    def copy_plugin_dirs
      @plugin_dirs.each do |plugin_dir|
        copy(plugin_dir, @lib_dir)
        plugins = Dir[File.join(plugin_dir, '/**/*.so')]
        copy_plugins(plugins)
      end
    end

    def copy_files(files)
      files.each do |from, to|
        dst = File.join(@directory, to)

        FileUtils.mkdir_p(dst)
        copy(from, dst)
      end
    end
  end
end