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
end
