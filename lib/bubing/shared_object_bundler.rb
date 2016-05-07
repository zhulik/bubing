module Bubing
  class SharedObjectBundler < Bubing::Bundler

    def bundle!
      super
      copy(@binary, @lib_dir)
    end
  end
end