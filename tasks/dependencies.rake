# frozen_string_literal: true

namespace :dependencies do
  desc "Copy package.json dependencies into vendor/javascript"
  task :vendor do
    node_modules = File.expand_path("../node_modules", __dir__)
    vendor = File.expand_path("../vendor/javascript", __dir__)

    # Copy @floating-ui/core and @floating-ui/dom ESM files to vendor
    FileUtils.cp(
      File.join(node_modules, '@floating-ui', 'core', 'dist', 'floating-ui.core.browser.mjs'),
      File.join(vendor, '@floating-ui--core.js')
    )
    FileUtils.cp(
      File.join(node_modules, '@floating-ui', 'dom', 'dist', 'floating-ui.dom.browser.mjs'),
      File.join(vendor, '@floating-ui--dom.js')
    )

    # Delete sourcemaps refs
    Dir.glob(File.join(vendor, '**', '*.js')).each do |file|
      content = File.read(file)

      File.write(file, content.gsub(/\/\/# sourceMappingURL=\S+/, ''))
    end
  rescue Errno::ENOENT
    puts "Error: Missing node_modules. Run `yarn install`."
  end
end
