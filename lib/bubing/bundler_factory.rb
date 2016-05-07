module Bubing
  class BundlerFactory
    def build(filename, directory, **options)
      info = Bubing::BinaryInfo.new(filename)
      options[:interpreter] = info.interpreter
      case info.type
      when :executable
        Bubing::ExecutableBundler.new(filename, directory, **options)
      when :shared_object
        Bubing::SharedObjectBundler.new(filename, directory, **options)
      end
    end
  end
end
