require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'activerecord'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'stonewall'

class Test::Unit::TestCase
end
