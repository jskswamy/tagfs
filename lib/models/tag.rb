require 'rubygems'
require 'neo4j'

class Tag < Neo4j::Rails::Model
 property :name, :null => false
 has_n(:files)
  
 index :name

 def add_file!(file)
  self.outgoing(:files) << file
  file.incoming(:tags) << self
 end

 def self.lookup(name)
  Tag.find(:name => name) || Tag.create!(:name => name)
 end
end
