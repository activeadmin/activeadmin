const execSync = require('child_process').execSync;
const gemPath = execSync('bundle show activeadmin', { encoding: 'utf-8' }).trim();

module.exports = {
  content: [
    `${gemPath}/vendor/javascript/flowbite.js`,
    `${gemPath}/plugin.js`,
    `${gemPath}/app/views/**/*.{arb,erb,html,rb}`,
    './app/admin/**/*.{arb,erb,html,rb}',
    './app/views/active_admin/**/*.{arb,erb,html,rb}',
    './app/views/admin/**/*.{arb,erb,html,rb}',
    './app/javascript/**/*.js'
  ],
  darkMode: "class",
  plugins: [
    require(`@activeadmin/activeadmin/plugin`)
  ]
}
