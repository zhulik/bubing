module Bubing
  class UnknownInterpreter < StandardError
  end

  class UnknownType < StandardError
  end

  class BinaryInfo
    X86_32_RE = /ELF 32-bit/
    X86_64_RE = /ELF 64-bit/

    EXECUTABLE_RE = /LSB executable/
    SHARED_OBJECT_RE = /LSB shared object/

    X86_32_INTERPRETER = 'ld-linux.so'
    X86_64_INTERPRETER = 'ld-linux-x86-64.so'

    attr_reader :interpreter, :type

    def initialize(binary)
      @binary = binary
      @file_output = `file #{@binary}`
      @interpreter = detect_interpreter
      @type = detect_type
    end

    private

    def detect_type
      case @file_output
        when EXECUTABLE_RE
          :executable
        when SHARED_OBJECT_RE
          :shared_object
        else
          raise Bubing::UnknownType
      end
    end

    def detect_interpreter
      case @file_output
        when X86_32_RE
          x86_32_interpreter
        when X86_64_RE
          x86_64_interpreter
        else
          raise Bubing::UnknownInterpreter
      end
    end

    def x86_32_interpreter
      libs = Dir['/lib/*']
      libs.detect{|l| l.include?(X86_32_INTERPRETER)}
    end

    def x86_64_interpreter
      libs = Dir['/lib/*']
      libs.detect{|l| l.include?(X86_64_INTERPRETER)}
    end
  end
end