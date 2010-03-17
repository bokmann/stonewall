$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module StoneWall
  # main hook into the framework.  From here, this should simply have methods that cause other includes to happen.
  def self.included(base)

    base.instance_eval do
      
      def stonewall()
        require File.expand_path(File.dirname(__FILE__)) + "/stonewall/controller.rb"
        require File.expand_path(File.dirname(__FILE__)) + "/stonewall/state.rb"
        require File.expand_path(File.dirname(__FILE__)) + "/stonewall/role.rb"
        cattr_accessor :acl
        self.acl = StoneWall::Controller.new(self)
        yield self.acl
      end
      
      def self.define_attribute_methods_with_hook
        define_attribute_methods_without_hook
        acl.fix_aliases if defined? self.acl
      end
      
      class << self
        alias_method "define_attribute_methods_without_hook", "define_attribute_methods"
        alias_method "define_attribute_methods", "define_attribute_methods_with_hook"
      end
    end
    
  end
end