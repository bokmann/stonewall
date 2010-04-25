require 'helper'

class TestGuardedClass < Test::Unit::TestCase
  
  context "with a user that had a role" do
    context "and an object with some reasonable permissions worthy of testing" do
      context "in the first state" do
        should "allow an unguarded method"
        should "allow a guarded method with the appropriate permissions"
        should "denied a guarded method without the appropriate permissions"
        should "allow a method group when all methods are allowed"
        should "deny a method group when one method in the group is denied"
      end
      
      context "in the second state" do
        should "allow an unguarded method"
        should "allow a guarded method with the appropriate permissions"
        should "denied a guarded method without the appropriate permissions"
        should "allow a method group when all methods are allowed"
        should "deny a method group when one method in the group is denied"
      end
    end
  end
end
