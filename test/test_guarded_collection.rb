require 'helper'

class TestGuardedCollection < Test::Unit::TestCase
  
  should "return true just to be a bad boy until my testing is in place" do
    assert true
  end
  
  context "with a homogenous collection of guarded objects" do
    context "where all allow a particular action" do
      should "return true with may_schpoo_any?"
      should "return true with may_schpoo_all?"
    end
    context "where only one allows a particular action" do
      should "return true with may_schpoo_any?"
      should "return false with may_schpoo_all?"
    end
    context "where none allows a particular action" do
      should "return false with may_schpoo_any?"
      should "return false with may_schpoo_all?"
    end
  end
end
