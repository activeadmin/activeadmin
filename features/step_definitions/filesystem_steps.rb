module ActiveAdminContentsRollback
  def files
    @files ||= {}
  end

  # Records the contents of a file the first time we are
  # about to change it
  def record(filename)
    contents        = File.read(filename) rescue nil
    files[filename] = contents            unless files.has_key? filename
  end

  # Rolls the recorded files back to their original states
  def rollback!
    files.each { |file, contents| rollback_file(file, contents) }
    @files = {}
  end

  # If the file originally had content, override the stuff on disk.
  # Else, remove the file and its parent folder structure until Rails.root OR other files exist.
  def rollback_file(file, contents)
    if contents.present?
      File.open(file, 'w') { |f| f << contents }
    else
      File.delete(file)
      begin
        dir = File.dirname(file)
        until dir == Rails.root
          Dir.rmdir(dir)                        # delete current folder
          dir = dir.split('/')[0..-2].join('/') # select parent folder
        end
      rescue Errno::ENOTEMPTY # Directory not empty
      end
    end
  end
end

World(ActiveAdminContentsRollback)

After '@changes-filesystem' do
  rollback!
end

Given /^"([^"]*)" contains:$/ do |filename, contents|
  path = Rails.root + filename
  FileUtils.mkdir_p File.dirname path
  record path

  File.open(path, 'w+') { |f| f << contents }
end

Given /^I add "([^"]*)" to the "([^"]*)" model$/ do |code, model_name|
  path = Rails.root.join "app", "models", "#{model_name}.rb"
  record path

  str = File.read(path).gsub /^(class .+)$/, "\\1\n  #{code}\n"
  File.open(path, 'w+') { |f| f << str }
  ActiveSupport::Dependencies.clear
end
