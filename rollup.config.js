import path from 'node:path';
import { URL, fileURLToPath } from 'node:url';
import { readFileSync } from 'node:fs';
import alias from '@rollup/plugin-alias';

const packageJson = JSON.parse(
  readFileSync(new URL('./package.json', import.meta.url))
);

const __dirname = fileURLToPath(new URL('.', import.meta.url));
const projectRootDir = path.resolve(__dirname);
const assetsDir = path.resolve(projectRootDir, 'app/javascript');


/**
 * @type {import('rollup').RollupOptions}
 */
export default [
  // build dist folder with all files from app/javascript using relative imports.
  // let bundler tools like webpack or rollup to process our package
  {
    input: ['app/javascript/active_admin.js'],
    output: {
      format: 'es',
      dir: 'dist',
      preserveModules: true,
    },
    external: Object.keys(packageJson.dependencies),
    plugins: [
      alias({
        entries: [
          {
            find: 'active_admin',
            replacement: path.join(assetsDir, 'active_admin'),
          },
        ]
      })
    ]
  }
];
