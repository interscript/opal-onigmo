require 'spec_helper'

RSpec.describe Onigmo::Regexp do
  it "can create a Regexp" do
    Onigmo::Regexp.new('(?<=test)test!', 'i')
  end

  it "can evaluate a Regexp" do
    re = Onigmo::Regexp.new('ll. wor', 'i')
    out = re.ffi_evaluate("Hello World!")
    expect(out).to eq(4)
    regs = re.ffi_region
    expect(regs).to eq([[4, 18]])
  end

  it "can find Hangul characters" do
    re = Onigmo::Regexp.new('\\p{Hangul}')
    out = re.ffi_evaluate("Some characters that are not Hangul and one that 봉is.")
    expect(out).to eq(98)
  end

  it "should support String#gsub" do
    require 'onigmo/core_ext'
    re = Onigmo::Regexp.new('aa')
    expect('aababaaaabbaaaba'.gsub(re, 'ZZ')).to eq('ZZbabZZZZbbZZaba')
  end

  it "should support String#gsub with $ correctly" do
    require 'onigmo/core_ext'
    re = Onigmo::Regexp.new('$')
    expect('lol'.gsub(re, '2')).to eq('lol2')
  end

  it "should support String#gsub with backparameters correctly" do
    require 'onigmo/core_ext'
    re = Onigmo::Regexp.new('(?<=te)(..)(?=st)')
    expect('texxst'.gsub(re, '\1\1')).to eq('texxxxst')
    expect('teyyst'.gsub(re) { "123" }).to eq('te123st')
  end

  it "should support String#sub" do
    re = Onigmo::Regexp.new('aa')
    expect('aababaaaabbaaaba'.sub(re, 'ZZ')).to eq('ZZbabaaaabbaaaba')
  end

  it "should support String#=~" do
    re = Onigmo::Regexp.new('aa')
    expect('haha' =~ re).to eq(nil)
    expect('haaha' =~ re).to eq(1)
  end

  it "should support String#match?" do
    require 'onigmo/core_ext'
    re = Onigmo::Regexp.new('aa')
    expect('haha'.match? re).to eq(false)
    expect('haaha'.match? re).to eq(true)
  end

  it "should support String#match" do
    require 'onigmo/core_ext'
    re = Onigmo::Regexp.new('aa')
    expect('haha'.match re).to eq(nil)
    expect('haaha'.match re).to be_a(MatchData)
  end

  it "should support $1, $2..." do
    require 'onigmo/core_ext'
    re = Onigmo::Regexp.new('(a).(a)')
    expect(re.match "haha").to be_a(MatchData)
    expect($1).to eq('a')
    expect($2).to eq('a')
  end
end
