import terser from "@rollup/plugin-terser";

const banner = `
/**
 Warning: This file is auto-generated, do not modify.
 Make your changes in 'app/javascript/active_admin' and run \`yarn build\`.
 */
//= require rails-ujs
//= require flowbite
`

const terserOptions = {
  mangle: false,
  compress: false,
  output: {
    beautify: true,
    indent_level: 2,
    comments: "all"
  }
}

export default {
  input: "app/javascript/active_admin/index.js",
  output: {
    file: "app/assets/javascripts/active_admin.js",
    format: "umd",
    banner: banner,
    globals: {
      "@rails/ujs": "Rails"
    }
  },
  plugins: [
    terser(terserOptions)
  ],
  // Use client's yarn dependencies instead of bundling everything
  external: [
    '@rails/ujs',
    'flowbite'
  ]
}
