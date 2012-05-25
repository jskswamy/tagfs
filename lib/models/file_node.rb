require 'rubygems'
require 'neo4j'

class FileNode < Neo4j::Rails::Model


  property :path, :null => false
  has_n(:tags)
  index :path
end

