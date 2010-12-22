module StoneWall
  class Parser
    def initialize(parent, role = :all, variant = :all)
      @parent, @role, @variant = parent, role, variant
      @method_groups = Hash.new
    end

    def allow(*alloweds)
      alloweds.flatten.each do |allowed|
        if @parent.stonewall.method_groups.keys.include?(allowed)
          @parent.stonewall.method_groups[allowed].each do |m|
            @parent.stonewall.add_grant(@role, @variant, m)
          end
        else
          @parent.stonewall.add_grant(@role, @variant, allowed)
        end
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
    
    def guard_aasm_events
      @parent.aasm_events.keys.each do |event|
        @parent.stonewall.actions[event] = Proc.new { |object, user|          
          User.do_as(user) {
            object.send(("may_" + event.to_s + "?").to_sym)
          }
        }
      end
    end
    
    def role(role_name)
      yield Parser.new(@parent, role_name)
    end

    def variant(variant_name)
      yield Parser.new(@parent, @role, variant_name)
    end

    def guard_attribute(*attributes)
      attributes.each do |m|
        StoneWall::Helpers.guard_attribute(@parent, m)
      end
    end
    alias_method :guard_attributes, :guard_attribute
    
    def guard_method(*methods)
      methods.each do |m|
        StoneWall::Helpers.guard_method(@parent, m)
      end
    end
    alias_method :guard_methods, :guard_method
    
  end
end