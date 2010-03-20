module StoneWall
  class Parser
    def initialize(parent, role = :all, variant = :all)
      @parent, @role, @variant = parent, role, variant
      @method_groups = Hash.new
    end

    def allowed_method(method)
      @parent.stonewall.add_grant(@role, @variant, method)
    end

    def allowed_methods(method_names)
      @parent.stonewall.method_groups[method_names].each do |m|
        allowed_method m
      end
    end

    def method_group(name, methods)
      @parent.stonewall.method_groups[name] = methods
    end

    def varies_on(field)
      @parent.stonewall.set_variant_field(field)
    end

    def action(action_name, &guard)
      @parent.stonewall.actions[action_name] = guard 
    end

    def role(role_name)
      yield Parser.new(@parent, role_name)
    end

    def variant(variant_name)
      yield Parser.new(@parent, @role, variant_name)
    end

    def guard(method)
      @parent.stonewall.guarded_methods << method
      aliased_target, punctuation = method.to_s.sub(/([?!=])$/, ''), $1
      checked_method = "#{aliased_target}_with_stonewall#{punctuation}"
      unchecked_method = "#{aliased_target}_without_stonewall#{punctuation}"    
      # --------------
      # This method is defined on the guarded class, so it is callable on
      # objects of that class.  This is 1/3rd of the magic of this gem-
      # if you declare 'schpoo' a guarded method, we generate this
      # 'schpoo_with_stonewall' method. Elsewhere, we use alias_method_chain
      # to wrap your original 'schpoo' method.
      @parent.send(:define_method, checked_method) do |*args|
        if stonewall.allowed?(self, User.current, method)
          self.send(unchecked_method, *args)
        else
          raise "Access Violation"
        end
      end
      # -------------- end of bizzaro meta-juju
    end

  end
end