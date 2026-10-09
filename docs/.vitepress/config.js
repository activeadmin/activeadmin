import packageInfo from '../../package.json' with { type: 'json' }
import { defineConfig } from 'vitepress'
import { generateLegacyRedirects } from './redirects.js'

function navigation(prefix, release) {
  return [
    { text: 'Guide', link: `${prefix}0-installation` },
    { text: 'Discuss', link: 'https://github.com/activeadmin/activeadmin/discussions' },
    {
      text: 'Demo',
      items: [
        { text: 'GitHub Repository', link: 'https://github.com/activeadmin/demo.activeadmin.info' },
        { text: 'Demo App', link: 'https://demo.activeadmin.info/' },
      ]
    },
    {
      text: release,
      items: [
        { text: 'Changelog', link: 'https://github.com/activeadmin/activeadmin/releases' },
        { text: 'Contributing', link: 'https://github.com/activeadmin/activeadmin/blob/master/CONTRIBUTING.md' },
      ],
    }
  ]
}

function sidebar(prefix, legacy = false) {
  return [
    {
      text: legacy ? 'v3 Setup' : 'v4 (beta) Setup',
      items: [
        { text: 'Installation', link: `${prefix}0-installation` },
        { text: 'Configuration', link: `${prefix}1-general-configuration` },
        { text: 'Upgrading', link: `${prefix}upgrading` },
      ]
    },
    {
      text: 'Resources',
      items: [
        { text: 'Working with Resources', link: `${prefix}2-resource-customization` },
        { text: 'Customize the Index page', link: `${prefix}3-index-pages` },
        { text: 'Index as a Table', link: `${prefix}${legacy ? '3-index-pages/index-as-table' : '3-index-as-table'}` },
        ...(legacy ? [
          { text: 'Index as a Grid', link: `${prefix}3-index-pages/index-as-grid` },
          { text: 'Index as Blocks', link: `${prefix}3-index-pages/index-as-block` },
          { text: 'Index as a Blog', link: `${prefix}3-index-pages/index-as-blog` },
          { text: 'Custom Index View', link: `${prefix}3-index-pages/custom-index` },
        ] : []),
        { text: 'CSV Format', link: `${prefix}4-csv-format` },
        { text: 'Forms', link: `${prefix}5-forms` },
        { text: 'Customize the Show Page', link: `${prefix}6-show-pages` },
        { text: 'Sidebar Sections', link: `${prefix}7-sidebars` },
        { text: 'Custom Controller Actions', link: `${prefix}8-custom-actions` },
        { text: 'Batch Actions', link: `${prefix}9-batch-actions` },
        { text: 'Decorators', link: `${prefix}11-decorators` },
        { text: 'Authorization Adapter', link: `${prefix}13-authorization-adapter` },
      ]
    },
    {
      text: 'Other',
      items: [
        { text: 'Custom Pages', link: `${prefix}10-custom-pages` },
        { text: 'Arbre Components', link: `${prefix}12-arbre-components` },
        { text: 'Gotchas', link: `${prefix}14-gotchas` },
      ]
    }
  ]
}

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: 'ActiveAdmin',
  description: 'The administration framework for business critical Ruby on Rails applications.',
  // Keep the source files in docs/ while publishing them at /docs/.
  rewrites: (page) => `docs/${page}`,
  buildEnd: generateLegacyRedirects,
  locales: {
    root: {
      label: 'v4 (beta)',
      lang: 'en',
      link: '/docs/',
      themeConfig: {
        nav: navigation('/docs/', packageInfo.version.replace('-', '.')),
        sidebar: sidebar('/docs/'),
      },
    },
    'docs/v3': {
      label: 'v3',
      lang: 'en',
      link: '/docs/v3/',
      title: 'ActiveAdmin v3',
      themeConfig: {
        nav: navigation('/docs/v3/', 'v3'),
        sidebar: sidebar('/docs/v3/', true),
      },
    },
  },
  head: [
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:locale', content: 'en' }],
    ['meta', { property: 'og:site_name', content: 'ActiveAdmin' }],
  ],
  themeConfig: {
    langMenuLabel: 'Documentation version',
    i18nRouting: (data, route, targetLocale) => {
      const destinations = {
        'docs/3-index-as-table.md': `/docs/v3/3-index-pages/index-as-table.md${route.hash}`,
        'docs/v3/3-index-pages/index-as-table.md': `/docs/3-index-as-table.md${route.hash}`,
        'docs/v3/3-index-pages/custom-index.md': '/docs/3-index-pages.md#custom-index',
        'docs/v3/3-index-pages/index-as-block.md': '/docs/3-index-pages.md',
        'docs/v3/3-index-pages/index-as-blog.md': '/docs/3-index-pages.md',
        'docs/v3/3-index-pages/index-as-grid.md': '/docs/3-index-pages.md',
      }
      const page = route.data.relativePath.replace(/^docs\/(?:v3\/)?/, '')
      const [destination, ...anchor] = (
        destinations[route.data.relativePath] ?? `${data.site.value.locales[targetLocale].link}${page}${route.hash}`
      ).split('#')
      const path = destination
        .replace(/(^|\/)index\.md$/, '$1')
        .replace(/\.md$/, data.site.value.cleanUrls ? '' : '.html')
      return path + route.query + (anchor.length ? '#' + anchor.join('#') : '')
    },
    editLink: {
      pattern: 'https://github.com/activeadmin/activeadmin/edit/master/docs/:path',
      text: 'Edit this page on GitHub'
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/activeadmin/activeadmin' },
      { icon: 'slack', link: 'https://activeadmin.slack.com/' },
    ],
    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2010-present'
    },
    search: {
      provider: 'local'
    }
  }
})
