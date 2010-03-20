module StoneWall
  def self.included(base)
    base.instance_eval do
      def stonewall()
        require File.expand_path(File.dirname(__FILE__)) +
                  "/access_controller.rb"
        require File.expand_path(File.dirname(__FILE__)) +
                  "/parser.rb"
        require File.expand_path(File.dirname(__FILE__)) +
                  "/helpers.rb"
        require File.expand_path(File.dirname(__FILE__)) +
                  "/user_extensions.rb"
        cattr_accessor :stonewall
        self.stonewall = StoneWall::AccessController.new(self)
        yield StoneWall::Parser.new(self)
      end

      # --------------
      # This is 1/3rd of the magic in this gem.  After ActiceRecord defines
      # the classes attribute methods, we come along and alias all of the
      # guarded methods defined in the dsl in the class.
      def self.define_attribute_methods_with_stonewall
        define_attribute_methods_without_stonewall
        StoneWall::Helpers.fix_aliases_for(self)
      end

      class << self
        alias_method_chain :define_attribute_methods, :stonewall
      end
    end

    # mimicking the send method, we want to ask permission first with send?
    def send?(method, user = User.current)
      self.class.stonewall.allowed?(self, user, method)
    end
  end
end