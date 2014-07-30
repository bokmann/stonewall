require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'activerecord'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'stonewall'

class Test::Unit::TestCase
end

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

class Doodad < ActiveRecord::Base
  include StoneWall
  stonewall do |s|
    s.action :pop do
      true
    end
    s.action :whiz do
      false
    end
  end
end
class User < ActiveRecord::Base; end

class CreateDoodads < ActiveRecord::Migration
  def self.up
    create_table :doodads do |t|
      t.string :thingy
    end
    create_table :users do |t|
      t.string :name
    end
  end
end
catch_output = CreateDoodads.up
