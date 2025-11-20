import js from "@eslint/js";

export default [
  {
    // as the sole object key, this ignores globally
    ignores: [
      "app/assets/**",
      "coverage/**",
      "docs/.vitepress/dist/**",
      "lib/generators/**",
      "src/**",
      "tmp/**",
      "vendor/**",
      "plugin.js"
    ],
  },
  {
    ...js.configs.recommended,
    languageOptions: {
      globals: {
        document: "readonly",
        FormData: "readonly",
        localStorage: "readonly",
        URLSearchParams: "readonly",
        window: "readonly",
      }
    },
  },
  {
    rules: {
      "no-unused-vars": ["error", { "argsIgnorePattern": "event" }],
    }
  },
];
