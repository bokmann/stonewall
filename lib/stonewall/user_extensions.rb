module StoneWall
  module UserExtensions
    require File.expand_path(File.dirname(__FILE__)) + "/helpers.rb"

    # This is the ugliest method in the whole gem.
    # You have a lot of freedom in how you implement your role system, and
    # I have to adapt to that.  You can have:
    #  - role as a string on your class
    #  - role as a singular has_one or belongs_to relationship
    #  - your user can has_many :roles, and they can be any object you want.
    # The only thing we require is that, if your role is a separate object,
    # it responds to a 'name' method with a string or a symbol that matches
    # the symbol you use when defining the permissions in your dsl.
    def stonepath_role_info
      return @role_symbols if @role_symbols
      @role_symbols = Array.new
      if self.respond_to?(:role)
        @role_symbols << StoneWall::Helpers.symbolize_role(role)
      end

      if self.respond_to?(:roles)
        roles.each do |role|
          @role_symbols << StoneWall::Helpers.symbolize_role(role)
        end
      end
      @role_symbols
    end

    # I like Aegis so much, I stole their idea for this part of the gem. I
    # hope you don't mind guys, but I really need an ACL that triggers off
    # of object state!
    def may_send?(object, method)
      object.class.stonewall.allowed?(object, self, method)
    end

    def method_missing_with_stonewall(symb, *args)
      method_name = symb.to_s
      if method_name =~ /^may_(.+?)[\!\?]$/
        args.first.class.stonewall.actions[$1.to_sym].call(args.first, self)
      else
        method_missing_without_stonewall(symb, *args)
      end
    end

    alias_method_chain :method_missing, :stonewall

  end
end