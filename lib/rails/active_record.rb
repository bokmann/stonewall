ActiveRecord::Base.class_eval do
  
  def method_missing_with_stonewall(symb, *args)
    method_name = symb.to_s
    if method_name =~ /^may_(.+?)[\!\?]$/
      guard = $1
      if guard.ends_with?("_any")
        guard = guard.gsub("_any", "").to_sym
        unless args.first.first.class.stonewall.actions[guard]
          return method_missing_without_stonewall(symb, *args)
        end
        args.first.any?{ |o| o.class.stonewall.actions[guard].call(o, self) }
      elsif guard.ends_with?("_all")
        guard = guard.gsub("_all", "").to_sym
        unless args.first.first.class.stonewall.actions[guard]
          return method_missing_without_stonewall(symb, *args)
        end
        args.first.all?{ |o| o.class.stonewall.actions[guard].call(o, self) }
      else
        unless args.first.class.stonewall.actions[guard.to_sym]
          return method_missing_without_stonewall(symb, *args)
        end
        args.first.class.stonewall.actions[guard.to_sym].call(args.first, self)
      end
    else
      method_missing_without_stonewall(symb, *args)
    end
  end

  
  alias_method_chain :method_missing, :stonewall
  
  
  # need to fix the update_attributes, read_attribute, and write_attribute problem here.
  
  def update_attributes_with_stonewall(*args)
    if respond_to?(:stonewall)
      args[0].keys.each do |attribute|
        attribute = attribute.to_sym unless attribute.class == Symbol
      
        if stonewall.guarded_attributes.include?(attribute)
           raise Stonewall::AccessViolationException.new " \n User id: #{User.current.id}\n User role info: #{User.current.stonewall_role_info}\n Number of Roles for User: #{User.current.stonewall_role_info.length}\n Class: #{self.class.name}\n Object id: #{self.id}\n Method: #{attribute}=" unless allowed?((attribute.to_s + "=").to_sym)
        end
      end
    end
    update_attributes_without_stonewall(*args)
  end
  alias_method_chain :update_attributes, :stonewall
  
  # design notes:
  # it is intentional that we are not blocking read_attribute and write_attribute methods.
  # These are rare in real world rails apps, and where they are being used, permissions
  # would generally be a hinderance.
  
  
end