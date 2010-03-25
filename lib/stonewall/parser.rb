module StoneWall
  class Parser
    def initialize(parent, role = :all, variant = :all)
      @parent, @role, @variant = parent, role, variant
      @method_groups = Hash.new
    end

    def allowed_method(*methods)
      methods.flatten.each do |m|
        @parent.stonewall.add_grant(@role, @variant, m)
      end
    end

    def allowed_methods(*methods)
      allowed_method(*methods)
    end
    
    def allowed_method_group(*group_names)
      group_names.flatten.each do |group_name|
        @parent.stonewall.method_groups[group_name].each do |m|
          allowed_method m
        end
      end
    end

    def allowed_method_groups(*group_names)
      allowed_method_group(group_names)
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

    def guard(*methods)
      methods.each do |m|
        StoneWall::Helpers.guard(@parent, m)
      end
    end

  end
end