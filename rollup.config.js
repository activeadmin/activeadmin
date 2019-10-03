import resolve from "rollup-plugin-node-resolve";
import commonjs from "rollup-plugin-commonjs";
import babel from "rollup-plugin-babel";
import { uglify } from "rollup-plugin-uglify";
import license from "rollup-plugin-license";
import { stripIndent } from 'common-tags';

const uglifyOptions = {
  mangle: false,
  compress: false,
  output: {
    beautify: true,
    indent_level: 2
  }
}

export default {
  input: "app/javascript/active_admin/base.js",
  output: {
    file: "app/assets/javascripts/active_admin/base.js",
    format: "umd",
    name: "ActiveAdmin"
  },
  plugins: [
    resolve(),
    commonjs(),
    babel(),
    uglify(uglifyOptions),
    license({
      banner: {
        commentStyle: 'none',
        // Add rails-style imports for sprockets usage
        content:stripIndent`
          /**
           * Warning: This file is auto-generated, do not modify. Instead, make your changes in 'app/javascript/active_admin/' and run \`yarn build\`
           */
          //= require jquery3
          //= require jquery-ui/widgets/datepicker
          //= require jquery-ui/widgets/dialog
          //= require jquery-ui/widgets/sortable
          //= require jquery-ui/widgets/tabs
          //= require jquery-ui/widget
          //= require jquery_ujs
          //= require_self
        ` + '\n'
      },
    }),
  ],
  // Use client's yarn dependencies instead of bundling everything
  external: [
    'jquery',
    'jquery-ui/ui/widgets/datepicker',
    'jquery-ui/ui/widgets/dialog',
    'jquery-ui/ui/widgets/sortable',
    'jquery-ui/ui/widgets/tabs',
    'jquery-ui/ui/widget',
    'jquery-ujs'
  ]
}
