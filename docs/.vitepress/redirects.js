import { mkdir, writeFile } from 'node:fs/promises'
import { dirname, join } from 'node:path'

// GitHub Pages needs real HTML files for the former root-level URLs.
// Generate old root URLs from the v3 archive, including pages removed from v4.
// The five archived index subpages do not depend on docs/3-index-pages/.
export async function generateLegacyRedirects({ outDir, pages, rewrites }) {
  for (const page of pages) {
    if (!page.startsWith('v3/')) continue

    const target = '/' + rewrites.map[page]
      .replace(/(^|\/)index\.md$/, '$1')
      .replace(/\.md$/, '.html')
    const output = join(outDir, page.slice('v3/'.length).replace(/\.md$/, '.html'))
    await mkdir(dirname(output), { recursive: true })
    await writeFile(output, `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Redirecting to ActiveAdmin documentation</title>
    <meta http-equiv="refresh" content="0; url=${target}">
    <link rel="canonical" href="https://activeadmin.info${target}">
    <script>window.location.replace(${JSON.stringify(target)} + window.location.search + window.location.hash)</script>
  </head>
  <body>
    <p>This page has moved to <a href="${target}">the ActiveAdmin documentation</a>.</p>
  </body>
</html>
`)
  }
}
