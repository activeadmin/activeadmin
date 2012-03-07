# More info at https://github.com/guard/guard#readme

guard 'rspec', :all_on_start => false, :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/active_admin/(.+)\.rb$})     { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
end

guard 'coffeescript', :output => 'spec/javascripts/compiled', :all_on_start => true  do
  watch(%r{spec/javascripts/coffeescripts/(.*)\.coffee})
end

guard 'sprockets', :destination => "app/assets/javascripts/active_admin/", :asset_paths => ['app/assets/javascripts/active_admin/coffeescripts/'] do
  watch(%r{^app/assets/javascripts/active_admin/coffeescripts/.+$})
end
