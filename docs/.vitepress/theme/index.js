import DefaultTheme from 'vitepress/theme'

import { redirects } from './redirects'

const URL_PARSE_BASE = 'https://example.invalid'

function normalizePath(pathname) {
  return pathname.replace(/\.html$/i, '')
}

function getRedirectTarget(to) {
  const url = new globalThis.URL(to, URL_PARSE_BASE)
  const redirectPath = redirects[normalizePath(url.pathname)]

  if (!redirectPath) {
    return null
  }

  return `${redirectPath}${url.search}${url.hash}`
}

export default {
  ...DefaultTheme,
  async enhanceApp(context) {
    await DefaultTheme.enhanceApp?.(context)

    const { router } = context

    router.onBeforeRouteChange = (to) => {
      const redirectTarget = getRedirectTarget(to)

      if (!redirectTarget) {
        return true
      }

      globalThis.setTimeout(() => {
        router.go(redirectTarget)
      })

      return false
    }
  },
}
