$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module StoneWall
  def self.included(base)

    base.instance_eval do
      
      def stonewall()
        require File.expand_path(File.dirname(__FILE__)) + "/stonewall/controller.rb"
        cattr_accessor :stonewall
        self.stonewall = StoneWall::Controller.new(self)
        yield self.stonewall
      end
      
      def self.define_attribute_methods_with_hook
        define_attribute_methods_without_hook
        stonewall.fix_aliases if defined? self.stonewall
      end
      
      class << self
        alias_method "define_attribute_methods_without_hook", "define_attribute_methods"
        alias_method "define_attribute_methods", "define_attribute_methods_with_hook"
      end
    end
  end
 
  module UserExtensions
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