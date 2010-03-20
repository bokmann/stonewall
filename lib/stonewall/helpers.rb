module StoneWall
  module Helpers

    def self.symbolize_role(role)
      [String, Symbol].include?(role.class) ? role.to_sym : role.name.to_sym
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
    def self.fix_aliases_for(guarded_class)
      guarded_class.stonewall.guarded_methods.each do |m|
        guarded_class.send(:alias_method_chain, m, :stonewall) 
      end
    end

  end
end