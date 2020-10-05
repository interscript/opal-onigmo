require 'onigmo/constants'
require 'onigmo/onigmo-wasm'
require 'onigmo/ffi'
require 'onigmo/regexp'

module Onigmo
  def self.buffer(str)
    Onigmo::FFI.context do
      @buffer_size ||= 1024
      @buffer ||= ::FFI::Pointer.new(:uint8, 640000) # 640 kB of RAM will be enough for everybody
      current_size = @buffer_size
      while str.length*2 > @buffer_size
        @buffer_size *= 2
      end
      @buffer.resize(@buffer_size) if current_size != @buffer_size
      @buffer.write_string(str)
      @buffer
    end
  end
end
