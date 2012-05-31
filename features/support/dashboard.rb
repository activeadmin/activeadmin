# Delete / Re-add dashboard.rb template
#

def add_default_dashboard
  dashboard_file = ENV['RAILS_ROOT'] + "/app/admin/dashboard.rb"
  dashboard_template = File.expand_path('../../../lib/generators/active_admin/install/templates/dashboard.rb', __FILE__)
  cmd = "cp #{dashboard_template} #{dashboard_file}"
  system cmd
end

Before do
  begin
    add_default_dashboard
  # I can't get cucumber to show errors when something wrong happen so I rescue
  # and print out any error.
  rescue
    p $!
    raise $!
  end
end

def delete_default_dashboard
  dashboard_file = ENV['RAILS_ROOT'] + "/app/admin/dashboard.rb"
  File.delete(dashboard_file) if File.exists?(dashboard_file)
end

Before '@dashboard' do
  begin
    delete_default_dashboard
  rescue
    p $!
    raise $!
  end
end
