module StoneWall
  module Helpers

    def self.symbolize_role(role)
      [String, Symbol].include?(role.class) ? role.to_sym : role.name.parameterize("_").downcase.to_sym
    end


    def self.fix_aliases_for(guarded_class)
      unless guarded_class.stonewall.nil?
        guarded_class.stonewall.guarded_methods.each do |m|
          fix_alias_for(guarded_class, m)
        end
      end
    end

    # --------------
    # This is 1/3rd of the magic in this gem.  We earlier built a
    # 'schpoo_with_stonewall' method on your class, and now we use
    # alias_method_chain to wrap your original 'schpoo' method.
    # You will have no hope of understanding this if you don't understand
    # alias_method_chain, so go memorize that documentation.
    # We have to do this after ActoveRecord synthesizes the attribute methods
    # with a call to 'define_attribute_methods'; you'll see some magic in the
    # base.instance_eval in the other file to make that magic happen.
    def self.fix_alias_for(guarded_class, m)
      guarded_class.send(:alias_method_chain, m, :stonewall)
    end
    
    
    def self.build_method_names(original_method_name)
      aliased_target, punctuation = original_method_name.to_s.sub(/([?!=])$/, ''), $1
      checked_method = "#{aliased_target}_with_stonewall#{punctuation}"
      unchecked_method = "#{aliased_target}_without_stonewall#{punctuation}"
      
      return checked_method, unchecked_method
    end
    
    
    #neither of these methods belong here - they seem like access controller things.
    # but I won't resolve that until we can do a proper refactoring with tests.
    def self.guard_method(guarded_class, m)
       guarded_class.stonewall.guarded_methods << m  #put this line where it belongs, and
                                                    #this method truly becomes a helper, doing nothing but
                                                    # defining the guard.
                                                    
      checked_method, unchecked_method = build_method_names(m)    
      
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
          raise Stonewall::AccessViolationException.new " \n User id: #{User.current.id}\n User Role Info: #{User.current.stonewall_role_info}\n Number of Roles for User: #{User.current.stonewall_role_info.length}\n Class: #{self.class.name}\n Object id: #{self.id}\n Method: #{checked_method}"
        end
      end
      # -------------- end of bizzaro meta-juju
    end
    
    def self.guard_attribute(guarded_class, a)
      guarded_class.stonewall.guarded_attributes << a
      guard_method(guarded_class, a)
      guarded_class.stonewall.method_groups[:readers] << a
      
      setter = (a.to_s + "=").to_sym
      guard_method(guarded_class, setter)
      guarded_class.stonewall.method_groups[:writers] << setter
    end
    
  end
end