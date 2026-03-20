import { defineAdditionalConfig } from 'vitepress'

export default defineAdditionalConfig({
  themeConfig: {
    nav: [
      { text: 'Guide', link: '/v3/0-installation' },
      { text: 'Discuss', link: 'https://github.com/activeadmin/activeadmin/discussions' },
      {
        text: 'Demo',
        items: [
          { text: 'GitHub Repository', link: 'https://github.com/activeadmin/demo.activeadmin.info' },
          { text: 'Demo App', link: 'https://demo.activeadmin.info/' },
        ],
      },
      {
        text: 'v3.x',
        items: [
          { text: 'v3.x', link: '/v3/0-installation' },
          { text: 'Changelog', link: 'https://github.com/activeadmin/activeadmin/releases' },
          { text: 'Contributing', link: 'https://github.com/activeadmin/activeadmin/blob/master/CONTRIBUTING.md' },
        ],
      },
    ],
    sidebar: [
      {
        text: 'Setup',
        items: [
          { text: 'Installation', link: '/v3/0-installation' },
          { text: 'Configuration', link: '/v3/1-general-configuration' },
        ],
      },
      {
        text: 'Resources',
        items: [
          { text: 'Working with Resources', link: '/v3/2-resource-customization' },
          { text: 'Customize the Index page', link: '/v3/3-index-pages' },
          { text: 'Index as a Table', link: '/v3/3-index-pages/index-as-table' },
          { text: 'Custom Index View', link: '/v3/3-index-pages/custom-index' },
          { text: 'CSV Format', link: '/v3/4-csv-format' },
          { text: 'Forms', link: '/v3/5-forms' },
          { text: 'Customize the Show Page', link: '/v3/6-show-pages' },
          { text: 'Sidebar Sections', link: '/v3/7-sidebars' },
          { text: 'Custom Controller Actions', link: '/v3/8-custom-actions' },
          { text: 'Batch Actions', link: '/v3/9-batch-actions' },
          { text: 'Decorators', link: '/v3/11-decorators' },
          { text: 'Authorization Adapter', link: '/v3/13-authorization-adapter' },
        ],
      },
      {
        text: 'Other',
        items: [
          { text: 'Custom Pages', link: '/v3/10-custom-pages' },
          { text: 'Arbre Components', link: '/v3/12-arbre-components' },
          { text: 'Gotchas', link: '/v3/14-gotchas' },
        ],
      },
    ],
    editLink: {
      pattern: 'https://github.com/activeadmin/activeadmin/edit/master/docs/:path',
      text: 'Edit this page on GitHub',
    },
  },
})
