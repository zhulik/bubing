module Bubing
  class BinaryBundler < Bubing::Bundler
    RUN_TEMPLATE = '%{envs} ./lib/%{interpreter} ./bin/%{binary}'

    def bundle!
      super
      log('Preparing run.sh...')
      run_file = make_run

      FileUtils.chmod('+x', run_file)
    end

    def make_run
      run_file = File.join(@directory, 'run.sh')
      envs = @envs.each_with_object([]) do |(k, v), ary|
        ary << "#{k}=#{v}"
      end.join(' ')
      run = RUN_TEMPLATE % {envs: envs, interpreter: File.basename(@interpreter), binary: File.basename(@binary)}
      File.open(run_file, 'w') do |file|
        file.write("#!/bin/bash\n")
        file.write("#{run}\n")
      end
      run_file
    end
  end
end