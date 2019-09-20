import resolve from "rollup-plugin-node-resolve"
import commonjs from "rollup-plugin-commonjs"
import babel from "rollup-plugin-babel"
import { uglify } from "rollup-plugin-uglify";

const uglifyOptions = {
  mangle: false,
  compress: false,
  output: {
    beautify: true,
    indent_level: 2
  }
}

export default {
  input: "app/javascript/active_admin/index.js",
  output: {
    file: "app/assets/javascripts/active_admin.js",
    format: "umd",
    name: "ActiveAdmin"
  },
  plugins: [
    resolve(),
    commonjs(),
    babel(),
    uglify(uglifyOptions)
  ],
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
