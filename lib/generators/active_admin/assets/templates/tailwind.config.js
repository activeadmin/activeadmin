const execSync = require('child_process').execSync;
const gemPath = execSync('bundle show activeadmin', { encoding: 'utf-8' }).trim();

module.exports = {
  content: [
    // './node_modules/@activeadmin/activeadmin/plugin.js',
    // './node_modules/@activeadmin/activeadmin/tailwind-*.css',
    // './node_modules/flowbite/**/*.js',
    `${gemPath}/plugin.js`,
    `${gemPath}/vendor/assets/javascripts/flowbite.js`,
    `${gemPath}/app/views/**/*.{arb,erb,html,rb}`,
    `${gemPath}/lib/**/*.{arb,erb,html,rb}`,
    './app/admin/**/*.{arb,erb,html,rb}',
    './app/views/**/*.{arb,erb,html,rb}',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  darkMode: "class",
  plugins: [
    // require('flowbite/plugin'),
    require(`${gemPath}/plugin`)
  ]
}
