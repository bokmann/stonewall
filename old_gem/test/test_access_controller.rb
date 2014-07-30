require 'helper'

class TestAccessController < Test::Unit::TestCase
  
  should "return true just to be a bad boy until my testing is in place" do
    assert true
  end
  
  should "hold a reference to the class it is guarding"
  
  should "keep track of the field we are varying behavior on"
  
  should "keep a list of guarded action blocks"
  
  should "keep a list of guarded methods"
  
  should "keep a list of method groups"
  
  should "tell me an r, v, m is guarded"

  should "tell me an r, v, m is not guarded"
  
  should "be able to use the 'add grant' method to add a new grant"
  
  should "delegate to the helpers to guard and fix aliases"
  
  should "return a 'grants' matrix"
  
  context "the 'allowed' method" do
    should "return 'true' when called on an unguarded method"
    
    should "return 'true' if the user is nil"
    
    should "return 'true' if the guarded object is nil"
    
    should "return 'true' if the method is nil"
    
    should "call user.stonewall_role_info and iterate through the results calling granted?"
  end
end
