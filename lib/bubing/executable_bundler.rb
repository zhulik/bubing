module Bubing
  class ExecutableBundler < Bubing::Bundler
    RUN_TEMPLATE = '%{envs} ./lib/%{interpreter} ./bin/%{binary} "$@"'

    def initialize(binary, directory, **options)
      super
      @bin_dir = File.join(@directory, 'bin')
      @run_script = options[:run_script] || 'run.sh'

      @envs = (options[:envs] || []).each_with_object({}) do |env, h|
        k, v = env.split('=')
        h[k] = v
      end
      if @envs['LD_LIBRARY_PATH'].nil?
        @envs['LD_LIBRARY_PATH'] = './lib'
      end
    end

    def bundle!
      super
      copy(@interpreter, @lib_dir)
      copy(@binary, @bin_dir)
      log("Preparing #{@run_script}...")
      run_file = make_run

      FileUtils.chmod('+x', run_file)
    end

    def make_run
      File.join(@directory, @run_script).tap do |run_file|
        envs = @envs.each_with_object([]) do |(k, v), ary|
          ary << "#{k}=#{v}"
        end.join(' ')
        run = RUN_TEMPLATE % {envs: envs, interpreter: File.basename(@interpreter), binary: File.basename(@binary)}
        File.open(run_file, 'w') do |file|
          file.write("#!/bin/bash\n")
          file.write("#{run}\n")
        end
      end
    end

    protected

    def prepare_dir
      super
      FileUtils.mkdir_p(@bin_dir)
    end
  end
end