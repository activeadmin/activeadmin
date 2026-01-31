import resolve from "rollup-plugin-node-resolve";
import commonjs from "rollup-plugin-commonjs";
import babel from "rollup-plugin-babel";
import { terser } from "rollup-plugin-terser";
import { stripIndent } from 'common-tags';

const terserOptions = {
  mangle: false,
  compress: false,
  output: {
    beautify: true,
    indent_level: 2,
    preamble: stripIndent`
      /**
       * Warning: This file is auto-generated, do not modify. Instead, make your changes in 'app/javascript/active_admin/' and run \`yarn build\`
       */
      //= require jquery4
      //= require jquery-ui/widgets/datepicker
      //= require jquery-ui/widgets/dialog
      //= require jquery-ui/widgets/sortable
      //= require jquery-ui/widgets/tabs
      //= require jquery-ui/widget
      //= require jquery_ujs
      //= require_self
    ` + '\n',
    wrap_func_args: false
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
    terser(terserOptions)
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
