module Bubing
  class DependencyNotFoundError < StandardError
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
    end

    def bundle!
      int = interpreter(@binary)
      deps = get_deps(int, @binary)
      FileUtils.rm_rf(@directory)
      FileUtils.mkdir_p(@directory)
      FileUtils.cp(deps, @directory)
      FileUtils.cp(@binary, @directory)
      FileUtils.cp(int, @directory)

      run_file = File.join(@directory, 'run.sh')
      run = RUN_TEMPLATE % { interpreter: File.basename(int), binary: File.basename(@binary) }
      File.open(run_file, 'w') do |file|
        file.write("#!/bin/bash\n")
        file.write("#{run}\n")
      end

      FileUtils.chmod('+x', run_file)
    end

    private

    def interpreter(binary)
      result = `file #{binary}`
      INTERPRETER_RE.match(result)[1]
    end

    def extract_path(lib)
      if lib.include?('not found')
        raise DependencyNotFoundError.new(lib)
      end
      File.absolute_path(PATH_RE.match(lib)[1].strip)
    end

    def get_deps(interpreter, file)
      trace = `LD_TRACE_LOADED_OBJECTS=1 #{interpreter} #{file}`
      trace.split("\n").map(&:strip).select{|row| row.include?('=>')}.map{|dep| extract_path(dep)}
    end
  end
end