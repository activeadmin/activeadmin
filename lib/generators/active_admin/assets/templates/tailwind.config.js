import { execSync } from 'child_process';
import activeAdminPlugin from '@activeadmin/activeadmin/plugin';

// Remove DEBUG to prevent bundler from outputting extra text
const { DEBUG: _, ...env } = { ...process.env };
const activeAdminPath = execSync('bundle show activeadmin', {
  encoding: 'utf-8',
  env
}).trim();

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
