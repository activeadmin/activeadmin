import { execSync } from 'child_process';
import activeAdminPlugin from '@activeadmin/activeadmin/plugin';

// Ensure only the last line of output is used from `bundle show activeadmin`,
// in case bundler prints extra lines (e.g., DEBUG enabled).
// Keep this assignment on a single line so that the Rails template `gsub_file`
// matches and replaces it correctly.
// Ref: https://github.com/activeadmin/activeadmin/pull/8891
const activeAdminPath = execSync('bundle show activeadmin', { encoding: 'utf-8' }).trim().split(/\r?\n/).pop();

export default {
  content: [
    `${activeAdminPath}/vendor/javascript/flowbite.js`,
    `${activeAdminPath}/plugin.js`,
    `${activeAdminPath}/app/views/**/*.{arb,erb,html,rb}`,
    './app/admin/**/*.{arb,erb,html,rb}',
    './app/views/active_admin/**/*.{arb,erb,html,rb}',
    './app/views/admin/**/*.{arb,erb,html,rb}',
    './app/views/layouts/active_admin*.{erb,html}',
    './app/javascript/**/*.js'
  ],
  darkMode: "selector",
  plugins: [
    activeAdminPlugin
  ]
}
