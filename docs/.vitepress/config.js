import { version } from '../../package.json'
import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "ActiveAdmin",
  description: "The administration framework for business critical Ruby on Rails applications.",
  head: [
    // ['link', { rel: 'icon', type: 'image/svg+xml', href: '/vitepress-logo-mini.svg' }],
    // ['link', { rel: 'icon', type: 'image/png', href: '/vitepress-logo-mini.png' }],
    // ['meta', { name: 'theme-color', content: '#5f67ee' }],
    ['meta', { name: 'og:type', content: 'website' }],
    ['meta', { name: 'og:locale', content: 'en' }],
    ['meta', { name: 'og:site_name', content: 'ActiveAdmin' }],
    // ['meta', { name: 'og:image', content: 'https://vitepress.dev/vitepress-og.jpg' }],
  ],
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Guide', link: '/0-installation' },
      { text: 'MD', link: '/markdown-examples' },
      { text: 'Discuss', link: 'https://github.com/activeadmin/activeadmin/discussions' },
      {
        text: version.replace("-", "."),
        items: [
          {
            text: 'Changelog',
            link: 'https://github.com/activeadmin/activeadmin/releases',
          },
          {
            text: 'Contributing',
            link: 'https://github.com/activeadmin/activeadmin/blob/master/CONTRIBUTING.md',
          },
        ],
      }
    ],
    sidebar: [
      {
        text: 'Setup',
        items: [
          { text: 'Installation', link: '/0-installation' },
          { text: 'Configuration', link: '/1-general-configuration' }
        ]
      },
      {
        text: 'Resources',
        items: [
          { text: 'Working with Resources', link: '/2-resource-customization' },
          { text: 'Customize the Index page', link: '/3-index-pages' },
          { text: 'Index as a Table', link: '/3-index-pages/index-as-table' },
          { text: 'Custom Index View', link: '/3-index-pages/custom-index' },
          { text: 'CSV Format', link: '/4-csv-format' },
          { text: 'Forms', link: '/5-forms' },
          { text: 'Customize the Show Page', link: '/6-show-pages' },
          { text: 'Sidebar Sections', link: '/7-sidebars' },
          { text: 'Custom Controller Actions', link: '/8-custom-actions' },
          { text: 'Batch Actions', link: '/9-batch-actions' },
          { text: 'Decorators', link: '/11-decorators' },
          { text: 'Authorization Adapter', link: '/13-authorization-adapter' }
        ]
      },
      {
        text: 'Other',
        items: [
          { text: 'Custom Pages', link: '/10-custom-pages' },
          { text: 'Arbre Components', link: '/12-arbre-components' },
          { text: 'Gotchas', link: '/14-gotchas' }
        ]
      }
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/activeadmin/activeadmin' },
      { icon: 'slack', link: 'https://activeadmin.slack.com/' },
    ],
    editLink: {
      pattern: 'https://github.com/activeadmin/activeadmin/edit/master/docs/:path',
      text: 'Edit this page on GitHub'
    },
    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2010-present'
    },
    search: {
      provider: 'local'
    }
  }
})
