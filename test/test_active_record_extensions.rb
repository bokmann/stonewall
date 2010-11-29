require 'helper'

class TestActiveRecordExtensions < Test::Unit::TestCase
  
  should "return true just to be a bad boy until my testing is in place" do
    assert true
  end
  
  should "define a method_missing_with_stonewall"
  
  should "call a stored action when we call a non-existent 'may_' method"
  
  should "chain method_missing"
  
  context 'may_ methods' do
    context 'checked against an instance of a class' do
      should 'call the stonewall action' do
        assert User.new.may_pop?(Doodad.new)
      end
      should 'raise an error if the given action does not exist' do
        assert_raise(NoMethodError){
          User.new.may_be_awesome?(Doodad.new)
        }
      end
    end
    context 'checked against a Class' do
      should 'call the stonewall action' do
        assert !User.new.may_whiz?(Doodad)
      end
      should 'raise an error if the given action does not exist' do
        assert_raise(NoMethodError){
          User.new.may_be_awesome?(Doodad)
        }
      end
    end
  end
end