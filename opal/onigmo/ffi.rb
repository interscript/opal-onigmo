require 'ffi'
require 'corelib/array/pack'
require 'corelib/string/unpack'

module Onigmo
  module FFI
    include Onigmo::Constants
    extend ::FFI::Library

    ffi_lib "onigmo/onigmo-wasm"

    class Regexp < ::FFI::Struct
      # This is defined mostly for debugging purposes
      layout :p, :pointer,
             :used, :uint,
             :alloc, :uint,

             :num_mem, :int,
             :num_repeat, :int,
             :num_null_check, :int,
             :num_comb_exp_check, :int,
             :num_call, :int,
             :capture_history, :uint,
             :bt_mem_start, :uint,
             :bt_mem_end, :uint,
             :stack_pop_level, :int,
             :repeat_range_alloc, :int,

             :options, :int,

             :repeat_range, :pointer,

             :encoding, :pointer,
             :syntax, :pointer,
             :name_table, :pointer,
             :casefold, :int,

             :optimize, :int,
             :threshold_len, :int,
             :anchor, :int,
             :anchor_dmin, :long,
             :anchor_dmax, :long,
             :sub_anchor, :int,
             :exact, :pointer,
             :exact_end, :pointer,
             :map, [:uchar, 256],

             :reserved1, :pointer,
             :reserved2, :pointer,
             :dmin, :long,
             :dmax, :long,

             :chain, :pointer
    end

    class RegexpPtr < ::FFI::Struct
      layout :value, Regexp.ptr

      def value
        self[:value]
      end
    end

    class Region < ::FFI::Struct
      layout :allocated, :int,
             :num_regs, :int,
             :beg, :pointer,
             :end, :pointer
    end

    class CompileInfo < ::FFI::Struct
      layout :num_of_elements, :int,
             :pattern_enc, :pointer,
             :target_enc, :pointer,
             :syntax, :pointer,
             :option, :uint,
             :case_fold_flag, :uint

      def self.default_compile_info
        @default ||= Onigmo::FFI.context do
          casefold = Onigmo::FFI.library.exports[:OnigDefaultCaseFoldFlag]
          casefold = casefold.value if casefold.respond_to? :value
          new.tap do |ci|
            ci[:num_of_elements] = 5
            ci[:pattern_enc] = Onigmo::FFI.library.exports[:OnigEncodingUTF_16LE]
            ci[:target_enc] = Onigmo::FFI.library.exports[:OnigEncodingUTF_16LE]
            ci[:syntax] = Onigmo::FFI.library.exports[:OnigSyntaxRuby]
            ci[:option] = Onigmo::FFI::ONIG_OPTION_NONE # To be overwritten
            ci[:case_fold_flag] = casefold
          end
        end
      end

      def options
        self[:option]
      end

      def options= value
        self[:option] = value
      end
    end

    class ErrorInfo < ::FFI::Struct
      layout :enc, :pointer,
             :par, :pointer,
             :par_end, :pointer

      def self.cached
        @cached ||= new
      end
    end

    attach_function :onig_new_deluxe, [RegexpPtr, :pointer, :pointer, CompileInfo, ErrorInfo], :int
    attach_function :onig_match, [Regexp, :pointer, :pointer, :pointer, Region, :uint], :int
    attach_function :onig_search, [Regexp, :pointer, :pointer, :pointer, :pointer, Region, :uint], :int
    attach_function :onig_free, [Regexp], :void

    attach_function :onig_region_new, [], Region
    attach_function :onig_region_free, [Region, :int], :void
  end

  Onigmo::FFI.library.memory.grow(128)
end
