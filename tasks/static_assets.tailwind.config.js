// TODO: I'm not sure why in lib/generators/active_admin/assets/templates/tailwind.config.js,
// `plugins` uses the plugin package, though `contents` uses the plugin.js from the gem.
// If that's by coincidence, and `plugins` can use the one from the gem,
// then we can use the template and don't need this file at all.
const execSync = require('child_process').execSync
const activeAdminPath = execSync('bundle show activeadmin', { encoding: 'utf-8' }).trim()

module.exports = {
  content: [
    `${activeAdminPath}/vendor/javascript/flowbite.js`,
    `${activeAdminPath}/plugin.js`,
    `${activeAdminPath}/app/views/**/*.{arb,erb,html,rb}`,
  ],
  darkMode: "selector",
  plugins: [
    `${activeAdminPath}/plugin.js`
  ]
}
