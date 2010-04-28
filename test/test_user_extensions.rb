require 'helper'

class TestUserExtensions < Test::Unit::TestCase
  
  should "define 'may_send?' on the user class"
  
  should "define a 'stonewall_role_info' method on the user class"
  
  context "the 'stonewall_role_info' method" do
    should "call the 'role' method if it is defined on the user"
    should "call the 'roles' method if it is defined on the user"
  end

end
