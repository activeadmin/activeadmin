# frozen_string_literal: true
module ActiveAdminContentsRollback
  def files
    @files ||= {}
  end

  def klasses
    @klasses ||= []
  end

  # Records the contents of a file the first time we are
  # about to change it
  def record(filename)
    contents = File.read(filename) rescue nil
    files[filename] = contents unless files.has_key? filename
  end

  # Rolls the recorded files back to their original states
  def rollback!
    files.each { |file, contents| rollback_file(file, contents) }
    @files = {}

    klasses.each { |klass| rollback_klass(klass) }
    @klasses = []
  end

  # If the file originally had content, override the stuff on disk.
  # Else, remove the file and its parent folder structure until Rails.root OR other files exist.
  def rollback_file(file, contents)
    if contents.present?
      File.open(file, "w") { |f| f << contents }
    else
      File.delete(file)
      begin
        dir = File.dirname(file)
        until dir == Rails.root
          Dir.rmdir(dir) # delete current folder
          dir = dir.split("/")[0..-2].join("/") # select parent folder
        end
      rescue Errno::ENOTEMPTY # Directory not empty
      end
    end
  end

  def record_file(filename, contents)
    path = Rails.root + filename
    FileUtils.mkdir_p File.dirname path
    record path

    File.open(path, "w+") { |f| f << contents }
  end

  def rollback_klass(klass)
    klass.reset_column_information
    klass.instance_variable_set(:@ransackable_attributes, nil)
  end

  def record_klass(klass)
    klasses << klass
    klass.reset_column_information
    klass.instance_variable_set(:@ransackable_attributes, nil)
  end

  def run(*command)
    require "open3"
    output, status = Open3.capture2e(*command, chdir: Rails.root)
    raise output unless status.success?
  end
end

World(ActiveAdminContentsRollback)

After "@changes-db-schema" do
  run("rails", "db:rollback")
  rollback!
end

After "@changes-filesystem or @requires-reloading" do
  rollback!
end

Given /^"([^"]*)" contains:$/ do |filename, contents|
  record_file(filename, contents)
end

Given /^I add "([^"]*)" to the "([^"]*)" model$/ do |code, model_name|
  path = Rails.root.join "app", "models", "#{model_name}.rb"
  record path

  str = File.read(path).gsub /^(class .+)$/, "\\1\n  #{code}\n"
  File.open(path, "w+") { |f| f << str }
end

Given /^a new "([^"]*)" counter column is added to "([^"]*)"$/ do |column_name, table_name|
  timestamp = Time.now.strftime("%Y%m%d%H%M%S")
  filename = "db/migrate/#{timestamp}_add_#{column_name}_to_#{table_name}.rb"
  contents = <<~RUBY
    class Add#{column_name.camelize}To#{table_name.camelize} < ActiveRecord::Migration[#{Rails::VERSION::MAJOR}.0]
      def change
        add_column :#{table_name}, :#{column_name}, :integer, default: 0
      end
    end
  RUBY
  record_file(filename, contents)
  run("rails", "db:migrate")
  record_klass(table_name.classify.constantize)
end
