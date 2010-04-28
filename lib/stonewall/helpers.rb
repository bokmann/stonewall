module StoneWall
  module Helpers

    def self.symbolize_role(role)
      [String, Symbol].include?(role.class) ? role.to_sym : role.name.parameterize("_").downcase.to_sym
    end


    def self.fix_aliases_for(guarded_class)
      guarded_class.stonewall.guarded_methods.each do |m|
        fix_alias_for(guarded_class, m)
      end
    end

    # --------------
    # This is 1/3rd of the magic in this gem.  We earlier built a
    # 'schpoo_with_stonepath' method on your class, and now we use
    # alias_method_chain to wrap your original 'schpoo' method.
    # You will have no hope of understanding this if you don't understand
    # alias_method_chain, so go memorize that documentation.
    # We have to do this after ActoveRecord synthesizes the attribute methods
    # with a call to 'define_attribute_methods'; you'll see some magic in the
    # base.instance_eval in the other file to make that magic happen.
    def self.fix_alias_for(guarded_class, m)
      guarded_class.send(:alias_method_chain, m, :stonewall)
    end
    
    
    # this is also a refactor-for-better-test opportunity.
    def self.guard(guarded_class, m)
      guarded_class.stonewall.guarded_methods << m
      aliased_target, punctuation = m.to_s.sub(/([?!=])$/, ''), $1
      checked_method = "#{aliased_target}_with_stonewall#{punctuation}"
      unchecked_method = "#{aliased_target}_without_stonewall#{punctuation}"    
      # --------------
      # This method is defined on the guarded class, so it is callable on
      # objects of that class.  This is 1/3rd of the magic of this gem-
      # if you declare 'schpoo' a guarded method, we generate this
      # 'schpoo_with_stonewall' method. Elsewhere, we use alias_method_chain
      # to wrap your original 'schpoo' method.
      guarded_class.send(:define_method, checked_method) do |*args|
        if stonewall.allowed?(self, User.current, m)
          self.send(unchecked_method, *args)
        else
          raise "Access Violation"
        end
      end
      # -------------- end of bizzaro meta-juju
    end
  end
end