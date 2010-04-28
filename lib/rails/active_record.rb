ActiveRecord::Base.class_eval do
  
  def method_missing_with_stonewall(symb, *args)
    method_name = symb.to_s
    if method_name =~ /^may_(.+?)[\!\?]$/
      args.first.class.stonewall.actions[$1.to_sym].call(args.first, self)
    else
      method_missing_without_stonewall(symb, *args)
    end
  end
  
  alias_method_chain :method_missing, :stonewall
  
  
  # need to fix the update_attributes, read_attribute, and write_attribute problem here.
  
end