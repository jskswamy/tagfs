require 'rb-fsevent'
DaemonKit::Application.running! do |config|
end

class State
  @@last_read_time = Time.now

  def self.last_read_time
    @@last_read_time
  end

  def self.last_read_time= read_time
    @@last_read_time = read_time
  end
end

class DirHelper
  def self.ignore_self_and_parent dir
     Dir.entries(dir).reject{|f| ['.','..'].include?(f)}
  end

  def self.get_full_path dir, files
    files.map { |file| File.join dir, file  }
  end

  def self.get_files dir
    self.get_full_path(dir,self.ignore_self_and_parent(dir))
  end
end

def list_files_changed(directories)
  files = DirHelper.get_files(directories.first).select { |file| File.ctime(file) > State.last_read_time unless File.directory? file }
  State.last_read_time = Time.now
end

fsevent = FSEvent.new
fsevent.watch '/Users/jskswamy/tagfs' do |directories|
  list_files_changed(directories)
end

fsevent.run