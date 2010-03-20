module StoneWall
  
  # used internally to parse the dsl.  This class is largely irrelevant in understanding
  # how to use this framework.  In short, it is the intermediary that helps parse the
  # dsl into a matrix of hashes.
  class Parser
    def initialize(parent, role, variant = :all)
      @parent, @role, @variant = parent, role, variant
    end
    
    #DSL Term
    def allowed_method(method)
      @parent.matrix[@role] ||= Hash.new
      @parent.matrix[@role][@variant] ||= Hash.new
      @parent.matrix[@role][@variant][method] ||= Hash.new
      @parent.matrix[@role][@variant][method] = true
    end
    
    #DSL Term
    def allowed_methods(method_names)
      @parent.method_groups[method_names].each do |m|
        allowed_method m
      end
    end
    
    #DSL Term
    def variant(variant_name)
      yield Parser.new(@parent, @role, variant_name)
    end  
  end
  
  
  # Every class guarded by Stonewall has a Controller.
  # I eventually want to rename this to be AccessController.
  #
  # On Objects of the guarded class, the accessors you declare as 'guard'ed
  # are wrapped with an alias_method_chain (look it up - you need to know that
  # to remove the magic of this framework).  The wrapped methods call 'allowed?'
  # on the AccessController for its class to determine if the permissions
  # allow that method to be executed.
  #
  # TODO:  This class currently has two reposibilities - parsing the DSL, and
  # working as the AccessController for each class on the running system.  I
  # think the architecture would be cleaner if that were split into two classes.
  class Controller
    attr_reader :guarded_class
    attr_reader :method_groups
    attr_reader :actions
    attr_reader :variant_field
    attr_accessor :matrix
    
    def initialize(guarded_class)
      @guarded_class = guarded_class
      @guarded_methods = Array.new
      @method_groups = Hash.new
      @actions = Hash.new
      @aliases = Array.new
      @matrix = Hash.new
    end

    # DSL Term
    def method_group(name, methods)
      @method_groups[name] = methods
    end

    # DSL Term
    def varies_on(state_name)
      if @variant_field.nil?
        @variant_field = state_name
      else
        raise "no redefinition of variant field"
      end
    end

    # DSL Term
    def role(role_name)
      yield Parser.new(self, role_name)
    end

    # DSL Term
    def action(action_name, &guard)
      @actions[action_name] = guard 
    end

    # DSL Term
    def guard(method)
      @guarded_methods << method
      checked_method = synthesized_method_name(method, "with")
      unchecked_method = synthesized_method_name(method, "without")
      
      # Meta to define the checked wrapper method.
      guarded_class.send(:define_method, checked_method) do |*args|
        if stonewall.allowed?(self, User.current, method)
          self.send(unchecked_method, *args)
        else
          raise "Access Violation"
        end
      end

      # # Save our needed aliases until later
      @aliases << [unchecked_method, method]
      @aliases << [method, checked_method]
    end

    def allowed?(guarded_object, user, method)
      return true if (guarded_object.nil? || user.nil? || method.nil?)

      variant = variant_field ? guarded_object.send(variant_field) : "all"
      return true if variant.nil?
      variant = variant.to_sym
      
      roles = (user.respond_to?(:roles) ? user.roles : [user.role]).collect{ |x| x.to_sym}
 
      roles.detect { |r| (matrix[r] && matrix[r][variant] && (matrix[r][variant][method] == true)) } || false
    end
    
    # fix up our saved aliases
    def fix_aliases
      @aliases.each do |src, target|
        guarded_class.send(:alias_method, src, target) # should we convert this to alias_method_chain?
      end
    end
          
    private

    # given a guarded method name, these two methods synthesize the checked and unchecked method names    
    def synthesized_method_name(method, s)
      method_name = method.to_s
      if method_name.include?("=")
        method_name.gsub!("=","")
        return "#{method_name}_#{s}_check="
      else
        return "#{method_name}_#{s}_check"
      end
    end
  end
end