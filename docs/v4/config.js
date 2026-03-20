import { version } from '../../package.json'
import { defineAdditionalConfig } from 'vitepress'

export default defineAdditionalConfig({
  themeConfig: {
    nav: [
      { text: 'Guide', link: '/v4/0-installation' },
      { text: 'Discuss', link: 'https://github.com/activeadmin/activeadmin/discussions' },
      {
        text: 'Demo',
        items: [
          { text: 'GitHub Repository', link: 'https://github.com/activeadmin/demo.activeadmin.info' },
          { text: 'Demo App', link: 'https://demo.activeadmin.info/' },
        ],
      },
      {
        text: version.replace("-", "."),
        items: [
          { text: version.replace("-", "."), link: '/v4/0-installation' },
          { text: '3.x (stable)', link: '/v3/0-installation' },
          { text: 'Changelog', link: 'https://github.com/activeadmin/activeadmin/releases' },
          { text: 'Contributing', link: 'https://github.com/activeadmin/activeadmin/blob/master/CONTRIBUTING.md' },
        ],
      },
    ],
    sidebar: [
      {
        text: 'Setup',
        items: [
          { text: 'Installation', link: '/v4/0-installation' },
          { text: 'Upgrading to v4', link: '/v4/upgrading' },
          { text: 'Configuration', link: '/v4/1-general-configuration' },
        ],
      },
      {
        text: 'Resources',
        items: [
          { text: 'Working with Resources', link: '/v4/2-resource-customization' },
          { text: 'Customize the Index page', link: '/v4/3-index-pages' },
          { text: 'Index as a Table', link: '/v4/3-index-pages/index-as-table' },
          { text: 'Custom Index View', link: '/v4/3-index-pages/custom-index' },
          { text: 'CSV Format', link: '/v4/4-csv-format' },
          { text: 'Forms', link: '/v4/5-forms' },
          { text: 'Customize the Show Page', link: '/v4/6-show-pages' },
          { text: 'Sidebar Sections', link: '/v4/7-sidebars' },
          { text: 'Custom Controller Actions', link: '/v4/8-custom-actions' },
          { text: 'Batch Actions', link: '/v4/9-batch-actions' },
          { text: 'Decorators', link: '/v4/11-decorators' },
          { text: 'Authorization Adapter', link: '/v4/13-authorization-adapter' },
        ],
      },
      {
        text: 'Other',
        items: [
          { text: 'Custom Pages', link: '/v4/10-custom-pages' },
          { text: 'Arbre Components', link: '/v4/12-arbre-components' },
          { text: 'Gotchas', link: '/v4/14-gotchas' },
        ],
      },
    ],
    editLink: {
      pattern: 'https://github.com/activeadmin/activeadmin/edit/master/docs/v4/:path',
      text: 'Edit this page on GitHub',
    },
  },
})
