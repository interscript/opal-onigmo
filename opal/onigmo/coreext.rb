require 'onigmo'

class String
  alias sub_before_onigmo sub
  def sub(from, to=nil, &block)
    if Onigmo::Regexp === from
      Onigmo.sub(self, from, to)
    else
      sub_before_onigmo(from, to, &block)
    end
  end

  alias gsub_before_onigmo gsub
  def gsub(from, to=nil, &block)
    if Onigmo::Regexp === from
      Onigmo.gsub(self, from, to)
    else
      gsub_before_onigmo(from, to, &block)
    end
  end

  alias match_before_onigmo match
  def match(re)
    if Onigmo::Regexp === re
      Onigmo.match(self, re)
    else
      match_before_onigmo(re)
    end
  end
end
