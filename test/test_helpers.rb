require 'helper'

class TestHelpers < Test::Unit::TestCase
  context "the symbolize_role method" do
    should "return a Symbol when passed a Symbol"
    should "return a Symbol when passed a String"
    should "return a Symbol when passed a Class with a name method"
  end
  
  should "fix aliases for a guarded class"
  
  should "fix an alias for a given guarded class and method"
  
  should "figure out the checked method name given a method name"
  
  should "fiure out the unchecked method name given a method name"
  
  should "define a checked meethod on the guarded class"
  
end
