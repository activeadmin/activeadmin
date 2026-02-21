# frozen_string_literal: true

namespace :dependencies do
  desc "Copy package.json dependencies into vendor/javascript"
  task :vendor do
    node_modules = File.expand_path("../node_modules", __dir__)
    vendor = File.expand_path("../vendor/javascript", __dir__)

    # Bundle @floating-ui/dom into a self-contained ESM file
    system("npx", "esbuild", "--bundle", "--format=esm", "--minify",
      File.join(node_modules, "@floating-ui", "dom", "dist", "floating-ui.dom.mjs"),
      "--outfile=#{File.join(vendor, '@floating-ui--dom.js')}"
    ) || abort("Error: esbuild failed to bundle @floating-ui/dom")

    # Delete sourcemaps refs
    Dir.glob(File.join(vendor, '**', '*.js')).each do |file|
      content = File.read(file)

      File.write(file, content.gsub(/\/\/# sourceMappingURL=\S+/, ''))
    end
  rescue Errno::ENOENT
    puts "Error: Missing node_modules. Run `yarn install`."
  end
end
