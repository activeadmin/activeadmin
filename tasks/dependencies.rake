# frozen_string_literal: true

namespace :dependencies do
  desc "Copy package.json dependencies into vendor/javascript"
  task :vendor do
    node_modules = File.expand_path("../node_modules", __dir__)
    vendor = File.expand_path("../vendor/javascript", __dir__)
    flowbite = File.join(node_modules, 'flowbite', 'dist', 'flowbite.min.js')

    abort "Error: Missing #{flowbite}. Run `npm install`." unless File.file?(flowbite)

    # Copy flowbite to vendor
    FileUtils.cp(flowbite, File.join(vendor, 'flowbite.js'))

    # Delete sourcemaps refs
    Dir.glob(File.join(vendor, '**', '*.js')).each do |file|
      content = File.read(file)

      File.write(file, content.gsub(/\/\/# sourceMappingURL=\S+/, ''))
    end
  end
end
