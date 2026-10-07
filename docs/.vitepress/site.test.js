import assert from 'node:assert/strict'
import { existsSync, readFileSync, readdirSync } from 'node:fs'
import { mkdtemp, readFile, rm } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { test } from 'node:test'
import { URL, fileURLToPath } from 'node:url'
import { runInNewContext } from 'node:vm'
import { generateLegacyRedirects } from './redirects.js'

const dist = fileURLToPath(new URL('./dist/', import.meta.url))
const read = (path) => readFileSync(join(dist, path), 'utf8')
const docsPages = readdirSync(fileURLToPath(new URL('../', import.meta.url)), { recursive: true })
  .filter((path) => path.endsWith('.md') && !path.startsWith('.') && !['index.md', 'v3/index.md'].includes(path))
  .sort()

test('every archived v3 page has a legacy redirect that preserves queries and anchors', () => {
  const pages = readdirSync(join(dist, 'docs/v3'), { recursive: true }).filter((path) => path.endsWith('.html'))
  for (const file of pages) {
    const path = file.replace(/\.html$/, '')
    const html = read(`${path}.html`)
    const destination = path === 'index' ? '/docs/v3/' : `/docs/v3/${path}.html`
    assert.ok(html.includes(`<meta http-equiv="refresh" content="0; url=${destination}">`))
    assert.ok(html.includes(`<a href="${destination}">`))
    assert.ok(html.includes(`href="https://activeadmin.info${destination}"`))
    assert.ok(existsSync(join(dist, destination, path === 'index' ? 'index.html' : '')))

    let redirected
    runInNewContext(html.match(/<script>(.*?)<\/script>/s)[1], {
      window: { location: {
        search: '?from=old-link',
        hash: '#index-filters',
        replace: (url) => { redirected = url },
      } },
    })
    assert.equal(redirected, `${destination}?from=old-link#index-filters`)
  }
})

test('all five archived index subpages and the overview have redirects without v4 counterparts', async () => {
  const outDir = await mkdtemp(join(tmpdir(), 'activeadmin-redirects-'))
  try {
    const indexPages = ['custom-index', 'index-as-block', 'index-as-blog', 'index-as-grid', 'index-as-table']
    const pages = ['v3/3-index-pages.md', ...indexPages.map((page) => `v3/3-index-pages/${page}.md`)]
    const currentOnly = '3-index-pages/v4-only.md'
    await generateLegacyRedirects({
      outDir,
      pages: [currentOnly, ...pages],
      rewrites: { map: Object.fromEntries([currentOnly, ...pages].map((page) => [page, `docs/${page}`])) },
    })
    for (const page of ['3-index-pages', ...indexPages.map((page) => `3-index-pages/${page}`)]) {
      const html = await readFile(join(outDir, `${page}.html`), 'utf8')
      assert.ok(html.includes(`content="0; url=/docs/v3/${page}.html"`), page)
    }
    assert.deepEqual(readdirSync(join(outDir, '3-index-pages')).sort(), indexPages.map((page) => `${page}.html`))
    assert.ok(!existsSync(join(outDir, '3-index-pages/v4-only.html')), 'A v4-only page must not create a legacy redirect')
  } finally {
    await rm(outDir, { recursive: true, force: true })
  }
})

test('index pages switch between consolidated v4 pages and archived v3 subpages', () => {
  for (const renderer of ['block', 'blog', 'grid']) {
    const legacy = read(`docs/v3/3-index-pages/index-as-${renderer}.html`)
    assert.ok(legacy.includes('href="/docs/3-index-pages.html"'), renderer)
    assert.ok(!legacy.includes(`href="/docs/3-index-pages/index-as-${renderer}.html"`), renderer)
  }
  for (const [page, destination] of [
    ['index-as-table', '/docs/3-index-as-table.html'],
    ['custom-index', '/docs/3-index-pages.html#custom-index'],
  ]) {
    const legacy = read(`docs/v3/3-index-pages/${page}.html`)
    assert.ok(legacy.includes(`href="${destination}"`), page)
    assert.ok(!legacy.includes(`href="/docs/3-index-pages/${page}.html"`), page)
  }
  assert.ok(read('docs/3-index-as-table.html').includes('href="/docs/v3/3-index-pages/index-as-table.html"'))
  assert.ok(read('docs/3-index-pages.html').includes('id="custom-index"'))
})

const versionDestinations = {
  '3-index-as-table.md': '/docs/v3/3-index-pages/index-as-table.html',
  'v3/3-index-pages/index-as-table.md': '/docs/3-index-as-table.html',
  'v3/3-index-pages/custom-index.md': '/docs/3-index-pages.html#custom-index',
  'v3/3-index-pages/index-as-block.md': '/docs/3-index-pages.html',
  'v3/3-index-pages/index-as-blog.md': '/docs/3-index-pages.html',
  'v3/3-index-pages/index-as-grid.md': '/docs/3-index-pages.html',
}

for (const page of docsPages) {
  const file = page.replace(/\.md$/, '.html')
  const legacy = page.startsWith('v3/')
  const prefix = legacy ? '/docs/v3/' : '/docs/'
  const otherPrefix = legacy ? '/docs/' : '/docs/v3/'
  const destination = versionDestinations[page] ?? otherPrefix + file.replace(/^v3\//, '')

  test(`/docs/${file} switches to the corresponding page and keeps its own sidebar`, () => {
    const html = read(`docs/${file}`)
    assert.ok(html.includes(`href="${destination}" rel="alternate"`), 'Version selector destination')
    assert.ok(html.includes('Documentation version'))

    const sidebar = html.match(/<aside class="VPSidebar"[^>]*>(.*?)<\/aside>/s)?.[1]
    assert.ok(sidebar, 'Documentation sidebar')
    assert.ok(sidebar.includes(`href="${prefix}0-installation.html"`))
    assert.ok(!sidebar.includes(`href="${otherPrefix}0-installation.html"`))
    if (legacy) {
      for (const indexPage of ['index-as-table', 'index-as-grid', 'index-as-block', 'index-as-blog', 'custom-index']) {
        assert.ok(sidebar.includes(`href="${prefix}3-index-pages/${indexPage}.html"`), indexPage)
      }
    } else {
      assert.ok(sidebar.includes('href="/docs/3-index-as-table.html"'))
      assert.ok(!sidebar.includes('href="/docs/3-index-pages/index-as-grid.html"'))
      assert.ok(!sidebar.includes('Custom Index View'))
    }
  })
}

test('every published docs link and asset exists in the deployment artifact', () => {
  for (const path of readdirSync(join(dist, 'docs'), { recursive: true }).filter((path) => path.endsWith('.html'))) {
    const page = new URL(`docs/${path}`, 'https://activeadmin.info/')
    for (const [, href] of read(`docs/${path}`).matchAll(/(?:href|src)="([^"]+)"/g)) {
      if (!href || href.startsWith('#')) continue
      const url = new URL(href, page)
      if (url.origin !== page.origin) continue
      const file = decodeURIComponent(url.pathname).replace(/\/$/, '/index.html')
      assert.ok(existsSync(join(dist, file)), `${page.pathname}: missing ${href}`)
    }
  }
})

for (const page of docsPages) {
  const file = page.replace(/\.md$/, '.html')
  test(`/docs/${file} has an edit link to its Markdown source`, () => {
    assert.ok(read(`docs/${file}`).includes(`href="https://github.com/activeadmin/activeadmin/edit/master/docs/${page}"`))
  })
}

test('the v4 upgrade guide includes breaking changes', () => {
  assert.ok(read('docs/upgrading.html').includes('Breaking Changes'))
})
