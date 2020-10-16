require 'onigmo'

class String
  alias match_before_onigmo match
  def match(re, pos = undefined, &block)
    if Onigmo::Regexp === re
      re.match(self, pos, &block)
    else
      match_before_onigmo(re, pos, &block)
    end
  end

  alias match_before_onigmo? match?
  def match?(re, pos = undefined, &block)
    if Onigmo::Regexp === re
      re.match?(self, pos, &block)
    else
      match_before_onigmo?(re, pos, &block)
    end
  end

  alias gsub_before_onigmo gsub
  def gsub(from, to = undefined, &block)
    if Onigmo::Regexp === from
      from.reset
      out = []
      index = 0
      loop do
        o = from.evaluate(self, index)
        if o == nil # not found anymore
          out << self[index..-1]
          break
        end
        bgn, fin = from.ffi_region[0].map { |i| i/2 }
        matches = from.matches

        md = MatchData.new(from, from.js_matches(self))

        out << self[index...bgn]

        if block && `to === undefined`
          out << block.(matches[0])
        else
          _to = to.JS.replace(%x{/([\\]+)([0-9+&`'\\])/g}) do |original, slashes, command|
            if slashes.length % 2 == 0
              original
            else
              slashes = slashes[0..-2]
              case command
              when "+", "&", "`", "'"
                raise NotImplementedError
              when "\\"
                slashes + "\\"
              else
                slashes + ( matches[command.to_i] || "" )
              end
            end
          end
          out << _to
        end

        if bgn == fin
          fin += 1
          out << self[bgn]
        end

        index = fin
      end

      out.join
    else
      gsub_before_onigmo(from, to, &block)
    end
  end

  alias sub_before_onigmo sub
  def sub(from, to = undefined, &block)
    if Onigmo::Regexp === from
      from.reset
    end
    sub_before_onigmo(from, to, &block)
  end
end
