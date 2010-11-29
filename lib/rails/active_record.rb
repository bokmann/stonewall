ActiveRecord::Base.class_eval do
  
  def method_missing_with_stonewall(symb, *args)
    method_name = symb.to_s
    if method_name =~ /^may_(.+?)[\!\?]$/
      klass = Class === args.first ? args.first : args.first.class
      klass.stonewall.actions[$1.to_sym].call(args.first, self)
    else
      method_missing_without_stonewall(symb, *args)
    end
  end
  
  alias_method_chain :method_missing, :stonewall
  
  
  # need to fix the update_attributes, read_attribute, and write_attribute problem here.
  
  def update_attributes_with_stonewall(*args)
    update_attributes_without_stonewall(*args)
  end
  alias_method_chain :update_attributes, :stonewall
  
  # design notes:
  # it is intentional that we are not blocking read_attribute and write_attribute methods.
  # These are rare in real world rails apps, and where they are being used, permissions
  # would generally be a hinderance.
end