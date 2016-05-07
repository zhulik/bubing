module Bubing
  class DependencyNotFoundError < StandardError
  end

  class BundlingError < StandardError
  end

  class Bundler
    INTERPRETER_RE = /interpreter (.+?(?=,))/
    PATH_RE = /=> (.+?(?=\())/
    RUN_TEMPLATE = 'LD_LIBRARY_PATH=./ ./%{interpreter} ./%{binary}'

    def initialize(binary, directory, plugins: [], plugin_dirs: [], verbose: false)
      @binary = binary
      @directory = directory
      @plugins = plugins
      @plugin_dirs = plugin_dirs
      @verbose = verbose
      @interpreter = interpreter(binary)
    end

    def bundle!
      log("Interpreter is #{@interpreter}")
      copy_deps(@binary)
      log('Copying plugins...')
      log("#{@plugins.count} plugins must be bundled")
      copy_plugins
      log('Preparing run.sh...')
      run_file = make_run

      FileUtils.chmod('+x', run_file)
      log('Done!')
    rescue Bubing::DependencyNotFoundError => e
      puts "#{e.message} not found!"
      raise Bubing::BundlingError
    end

    private

    def interpreter(binary)
      result = `file #{binary}`
      INTERPRETER_RE.match(result)[1]
    end

    def extract_path(lib)
      if lib.include?('not found')
        raise DependencyNotFoundError.new(lib.split('=>')[0].strip)
      end
      File.absolute_path(PATH_RE.match(lib)[1].strip)
    end

    def get_deps(file)
      trace = `LD_TRACE_LOADED_OBJECTS=1 #{@interpreter} #{file}`
      trace.split("\n").map(&:strip).select{|row| row.include?('=>')}.map{|dep| extract_path(dep)}
    end

    def log(message)
      puts message if @verbose
    end

    def copy_deps(binary)
      log("Bundling $#{binary}")
      deps = get_deps(binary)
      log("#{deps.count} dependencies found")
      log('Copying dependencies...')
      FileUtils.rm_rf(Dir.glob(File.join(@directory, '*')))
      FileUtils.mkdir_p(@directory)
      FileUtils.cp(deps, @directory)
      FileUtils.cp(@binary, @directory)
      FileUtils.cp(@interpreter, @directory)
    end

    def make_run
      run_file = File.join(@directory, 'run.sh')
      run = RUN_TEMPLATE % {interpreter: File.basename(@interpreter), binary: File.basename(@binary)}
      File.open(run_file, 'w') do |file|
        file.write("#!/bin/bash\n")
        file.write("#{run}\n")
      end
      run_file
    end

    def copy_plugins
      @plugins.each do |plugin|
        copy_deps(plugin)
      end
    end
  end
end