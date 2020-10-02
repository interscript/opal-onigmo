module Onigmo
  class Regexp
    `Opal.defineProperty(self.$$prototype, '$$is_regexp', true)`
    # Hacks in order to make it more alike JS regexp that is perfectly compatible.
    # This should make String#sub and friends work without a hassle.
    `Opal.defineProperty(self.$$prototype, 'global', true)`
    `Opal.defineProperty(self.$$prototype, 'multiline', true)`

    def match(str, offset=nil, &block)
    end

    def match?(str, offset=nil, &block)
    end

    def =~ str
    end

    def initialize
      @lastIndex = nil # ??
      @scan = method(:match)
    end
  end
end
