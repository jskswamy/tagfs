def track_file(file_path, tags)
  file = FileNode.create!(:path => file_path)

  tags.each do |tag|
    Tag.lookup(tag).add_file!(file)
  end
end
