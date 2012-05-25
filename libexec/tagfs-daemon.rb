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

def get_files_with_ctime dir
  files = Dir.entries(dir).select do |file|
    file_path = File.join dir, file
    !(File.directory? file) && File.ctime(file_path) > State.last_read_time
  end
  files.map do |f|
    file_path = File.join dir, f
    file_ctime = File.ctime(file_path)
    {:file_name => file_path, :ctime => File.ctime(file_path)}
  end
end

def list_files_changed(directories)
  files = get_files_with_ctime( directories.first)
  State.last_read_time = Time.now
end

fsevent = FSEvent.new
fsevent.watch '/Users/jskswamy/tagfs' do |directories|
  list_files_changed(directories)
end

fsevent.run