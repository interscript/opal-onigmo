module Onigmo
  class Regexp
    `Opal.defineProperty(self.$$prototype, '$$is_regexp', true)`
    # Hacks in order to make it more alike JS regexp that is perfectly compatible.
    # This should make String#sub and friends work without a hassle.
    `Opal.defineProperty(self.$$prototype, 'global', true)`
    `Opal.defineProperty(self.$$prototype, 'multiline', true)`

    def match(str, offset=nil, &block)
      self.reset
      block ||= proc{|i| i}
      evaluate(str, offset) && block.(MatchData.new(self, js_matches(str)))
    end

    def match?(str, offset=nil)
      self.reset
      !!evaluate(str, offset)
    end

    def =~ str
      match(str) && $~.begin(0)
    end

    def inspect
      "/#{pattern.inspect[1..-2]}/O#{options}"
    end

    def initialize pattern, options = ''
      if pattern.is_a? Onigmo::Regexp
        pattern = pattern.pattern
      end

      @lastIndex = 0
      @pattern = pattern.encode("UTF-16LE")
      @options = options

      out = nil
      Onigmo::FFI.context do
        ffi_regexpptr = Onigmo::FFI::RegexpPtr.new
        ffi_options = Onigmo::FFI::CompileInfo.default_compile_info
        ffi_errorinfo = Onigmo::FFI::ErrorInfo.cached

        ffi_pattern = Onigmo.buffer(@pattern)
        ffi_pattern_end = ffi_pattern + (@pattern.length * 2)

        ffi_options.options  = Onigmo::FFI::ONIG_OPTION_NONE
        ffi_options.options |= Onigmo::FFI::ONIG_OPTION_IGNORECASE if options.include? "i"
        ffi_options.options |= Onigmo::FFI::ONIG_OPTION_MULTILINE if options.include? "m"
        ffi_options.options |= Onigmo::FFI::ONIG_OPTION_EXTEND if options.include? "x"

        out = Onigmo::FFI.onig_new_deluxe(ffi_regexpptr, ffi_pattern, ffi_pattern_end,
                                    ffi_options, ffi_errorinfo)

        @ffi_regexp = ffi_regexpptr.value
        ffi_regexpptr.free
      end

      @exec = proc { |re| js_exec(re) }

      unless out == Onigmo::FFI::ONIG_NORMAL
        raise RuntimeError, "Onigmo has failed with an error code '#{out}'"
      end
    end

    attr_accessor :pattern, :options

    def ffi_evaluate string, offset = 0
      offset ||= 0

      @ffi_region = Onigmo::FFI.onig_region_new

      string = string.encode("UTF-16LE")

      out = Onigmo::FFI.context do
        ffi_string = Onigmo.buffer(string)
        ffi_string_end = ffi_string + (string.length * 2)
        ffi_string_offset = ffi_string + offset * 2

        Onigmo::FFI.onig_search(@ffi_regexp, ffi_string, ffi_string_end, ffi_string_offset,
                                ffi_string_end, @ffi_region, Onigmo::FFI::ONIG_OPTION_NONE)
      end

      @region = @ffi_region[:num_regs].times.map do |i|
        [@ffi_region[:beg].get(:long, i*4),
         @ffi_region[:end].get(:long, i*4) ]
      end

      Onigmo::FFI.onig_region_free(@ffi_region, 1)

      @matches = @region.map { |b,e| string[b/2...e/2] }

      out
    end

    def ffi_region
      @region
    end

    def matches
      @matches
    end

    def ffi_free
      Onigmo::FFI.onig_free(@ffi_regexp)
    end

    def evaluate string, offset = 0
      out = ffi_evaluate(string, offset)
      if out < 0
        nil
      else
        out / 2
      end
    end

    def js_matches(str)
      ms = matches
      region = ffi_region
      out = {
        input: str,
        index: region[0][0]/2,
        length: ms.length,
        slice: proc { |i| matches[i..-1] }
      }
      out = out.to_n
      ms.each_with_index { |m,i| `out[#{i}] = #{m}` }
      @lastIndex = region[0][1]/2
      out
    end

    def js_exec(str)
      if evaluate(str, @lastIndex || 0)
        js_matches(str)
      else
        @lastIndex = 0
        nil.to_n
      end
    end

    def reset
      @lastIndex = 0
      self
    end
  end
end
