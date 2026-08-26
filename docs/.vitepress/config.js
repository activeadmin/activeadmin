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
      { text: 'Guide', link: '/v3/0-installation' },
      { text: 'Discuss', link: 'https://github.com/activeadmin/activeadmin/discussions' },
      {
        text: 'Demo',
        items: [
          { text: 'GitHub Repository', link: 'https://github.com/activeadmin/demo.activeadmin.info' },
          { text: 'Demo App', link: 'https://demo.activeadmin.info/' },
        ]
      },
      {
        text: 'v3.x', // use Ruby format for version text
        items: [
          {
            text: 'v3.x',
            link: '/v3/0-installation'
          },
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
