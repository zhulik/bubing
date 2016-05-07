module Bubing
  class UnknownInterpreter < StandardError
  end

  class InterpreterDetector
    X86_32_RE = /ELF 32-bit/
    X86_64_RE = /ELF 64-bit/

    X86_32_INTERPRETER = 'ld-linux.so'
    X86_64_INTERPRETER = 'ld-linux-x86-64.so'

    def initialize(binary)
      @binary = binary
    end

    def detect
      file = `file #{@binary}`
      case file
        when X86_32_RE
          x86_32_interpreter
        when X86_64_RE
          x86_64_interpreter
        else
          raise Bubing::UnknownInterpreter
      end
    end

    private

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