require 'helper'

class TestActiveRecordExtensions < Test::Unit::TestCase
  
  should "return true just to be a bad boy until my testing is in place" do
    assert true
  end
  
  should "define a method_missing_with_stonewall"
  
  should "call a stored action when we call a non-existent 'may_' method"
    
  should "chain method_missing"
  
  context 'may_ methods' do
      should 'call the stonewall action' do
        assert User.new.may_pop?(Doodad.new)
      end
      should 'raise an error if the given action does not exist' do
        assert_raise(NoMethodError){
          User.new.may_be_awesome?(Doodad.new)
        }
      end
    context "ending in '_any?'" do
      should 'call the stonewall action' do
        doodads = Array.new
        doodads << Doodad.new
        doodads << Doodad.new
        assert User.new.may_pop_any?(doodads)
      end
    end
    
    context "ending in '_all?'" do
      should 'call the stonewall action' do
        doodads = Array.new
        doodads << Doodad.new
        doodads << Doodad.new
        assert User.new.may_pop_all?(doodads)
      end
    end
         
  end
end
