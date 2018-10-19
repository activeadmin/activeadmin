desc "Run the full suite using 1 core"
task test: [:setup, :spec, :cucumber]

desc "Run the specs"
task :spec do
  system("rspec")
end

desc "Run the cucumber scenarios"
task cucumber: [:"cucumber:regular", :"cucumber:reloading"]

namespace :cucumber do

  desc "Run the standard cucumber scenarios"
  task :regular do
    system("cucumber")
  end

  desc "Run the cucumber scenarios that test reloading"
  task :reloading do
    system("cucumber --profile class-reloading")
  end

end
