$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) ||
  $:.include?(File.expand_path(File.dirname(__FILE__)))

require File.expand_path(File.dirname(__FILE__)) + "/stonewall/stonewall.rb"
require File.expand_path(File.dirname(__FILE__)) + "/stonewall/user_extensions.rb"