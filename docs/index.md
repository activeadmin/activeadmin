---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: ActiveAdmin
  text: An admin engine for Rails applications
  tagline: Abstracts common patterns to implement beautiful and elegant interfaces with ease.

  actions:
    - theme: brand
      text: Getting Started
      link: /0-installation
    - theme: alt
      text: View on GitHub
      link: https://github.com/activeadmin/activeadmin

features:
  - icon: 🌎
    title: Global Navigation
    details: Customizable navigation allows you to create usable admin interfaces for your business.
  - icon: 🔒
    title: User Authentication
    details: Use the bundled Devise configuration or implement your own authorization using the provided hooks.
  - icon: 🎬
    title: Action Items
    details: Add buttons or links as action items in the page header for a resource.
    link: /8-custom-actions
    linkText: Learn about action items
  - icon: 🔍
    title: Filters
    details: Allow users to filter resources by searching strings, text fields, dates, and numeric values.
    link: /3-index-pages
    linkText: Learn about filters
  - icon: 🗂️
    title: Scopes
    details: Use scopes to create sections of mutually exclusive resources for quick navigation and reporting.
  - icon: 📑
    title: Custom Index Views
    details: The default index screen is a table view, but custom index views are supported.
  - icon: 📋
    title: Sidebar Sections
    details: Add your own sections to the sidebar using a simple DSL.
    link: /7-sidebars
    linkText: Learn about sidebar sections
  - icon: 💾
    title: Downloads
    details: Each resource becomes available as CSV, JSON, and XML with customizable output.
---
