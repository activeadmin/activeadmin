import plugin from 'tailwindcss/plugin';
import defaultTheme from 'tailwindcss/defaultTheme';
import colors from 'tailwindcss/colors';
const { spacing, borderWidth, borderRadius } = defaultTheme;

// https://github.com/tailwindlabs/tailwindcss/discussions/9336
// https://github.com/tailwindlabs/tailwindcss/discussions/2049
// https://github.com/tailwindlabs/tailwindcss/discussions/2049#discussioncomment-45546

const svgToTinyDataUri = (() => {
  // Source: https://github.com/tigt/mini-svg-data-uri
  const reWhitespace = /\s+/g,
    reUrlHexPairs = /%[\dA-F]{2}/g,
    hexDecode = { '%20': ' ', '%3D': '=', '%3A': ':', '%2F': '/' },
    specialHexDecode = match => hexDecode[match] || match.toLowerCase(),
    svgToTinyDataUri = svg => {
      svg = String(svg);
      if (svg.charCodeAt(0) === 0xfeff) svg = svg.slice(1);
      svg = svg
        .trim()
        .replace(reWhitespace, ' ')
        .replaceAll('"', '\'');
      svg = encodeURIComponent(svg);
      svg = svg.replace(reUrlHexPairs, specialHexDecode);
      return 'data:image/svg+xml,' + svg;
    };
  svgToTinyDataUri.toSrcset = svg => svgToTinyDataUri(svg).replace(/ /g, '%20');
  return svgToTinyDataUri;
})();

export default plugin(
  function({ addBase, addComponents, theme }) {
    addBase({
      [[
        "[type='text']",
        "[type='email']",
        "[type='url']",
        "[type='password']",
        "[type='number']",
        "[type='date']",
        "[type='datetime-local']",
        "[type='month']",
        "[type='search']",
        "[type='tel']",
        "[type='time']",
        "[type='week']",
        'textarea',
        'select',
      ]]: {
        '@apply dark:scheme-dark': {},
        'appearance': 'none',
        'padding': `${spacing[2]} ${spacing[3]}`,
        '--tw-shadow': '0 0 #0000',
        '&:focus': {
          outline: '2px solid transparent',
          'outline-offset': '2px',
          '--tw-ring-inset': 'var(--tw-empty,/*!*/ /*!*/)',
          '--tw-ring-offset-width': '0px',
          '--tw-ring-offset-color': '#fff',
          '--tw-ring-color': theme(
            'colors.blue.600',
            colors.blue[600]
          ),
          '--tw-ring-offset-shadow': `var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color)`,
          '--tw-ring-shadow': `var(--tw-ring-inset) 0 0 0 calc(1px + var(--tw-ring-offset-width)) var(--tw-ring-color)`,
          'box-shadow': `var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow)`,
          'border-color': theme('colors.blue.600', colors.blue[600]),
        },
      },
      ['::-webkit-datetime-edit']: {
        display: 'inline-flex',
      },
      [[
        '::-webkit-datetime-edit',
        '::-webkit-datetime-edit-year-field',
        '::-webkit-datetime-edit-month-field',
        '::-webkit-datetime-edit-day-field',
        '::-webkit-datetime-edit-hour-field',
        '::-webkit-datetime-edit-minute-field',
        '::-webkit-datetime-edit-second-field',
        '::-webkit-datetime-edit-millisecond-field',
        '::-webkit-datetime-edit-meridiem-field',
      ]]: {
        'padding-bottom': '0',
        'padding-top': '0',
      },
      ['::-webkit-date-and-time-value']: {
        'min-height': '1.5em',
        'text-align': 'inherit',
      },
      ['select']: {
        'background-image': `url("${svgToTinyDataUri(
          `<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
            <path stroke="${theme('colors.gray.500', colors.gray[500])}" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/>
          </svg>`
        )}")`,
        'background-position': `right ${spacing[3]} center`,
        'background-repeat': `no-repeat`,
        'background-size': `0.75em 0.75em`,
        'padding-inline-end': spacing[8],
        'print-color-adjust': `exact`,
      },
      [':is(:where([dir=rtl]) select)']: {
        'background-position': `left ${spacing[3]} center`,
      },
      ['[multiple]']: {
        'background-image': 'initial',
        'background-position': 'initial',
        'background-repeat': 'unset',
        'background-size': 'initial',
        'padding-inline-end': spacing[3],
        'print-color-adjust': 'unset',
      },
      [[`[type='checkbox']`, `[type='radio']`]]: {
        appearance: 'none',
        'background-origin': 'border-box',
        color: theme('colors.blue.600', colors.blue[600]),
        display: 'inline-block',
        'flex-shrink': '0',
        'print-color-adjust': 'exact',
        'user-select': 'none',
        'vertical-align': 'middle',
        '--tw-shadow': '0 0 #0000',
      },
      [[`[type='checkbox']:focus`, `[type='radio']:focus`]]: {
        outline: '2px solid transparent',
        'outline-offset': '2px',
        '--tw-ring-inset': 'var(--tw-empty,/*!*/ /*!*/)',
        '--tw-ring-offset-width': '2px',
        '--tw-ring-offset-color': '#fff',
        '--tw-ring-color': theme('colors.blue.600', colors.blue[600]),
        '--tw-ring-offset-shadow': `var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color)`,
        '--tw-ring-shadow': `var(--tw-ring-inset) 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-ring-color)`,
        'box-shadow': `var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow)`,
      },
      [[
        `[type='checkbox']:checked`,
        `[type='checkbox']:indeterminate`,
        `[type='radio']:checked`,
      ]]: {
        'background-color': `currentColor`,
        'background-position': `center`,
        'background-repeat': `no-repeat`,
        'background-size': `100% 100%`,
        'border-color': `transparent`,
      },
      [`[type='checkbox']:checked`]: {
        'background-image': `url("${svgToTinyDataUri(
          `<svg viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M4 8 L7 11 L12 5" stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" />
          </svg>`
        )}")`,
        'print-color-adjust': `exact`,
      },
      [`[type='radio']:checked`]: {
        'background-image': `url("${svgToTinyDataUri(
          `<svg viewBox="0 0 16 16" fill="white" xmlns="http://www.w3.org/2000/svg"><circle cx="8" cy="8" r="3"/></svg>`
        )}")`,
      },
      [`[type='checkbox']:indeterminate`]: {
        'background-image': `url("${svgToTinyDataUri(
          `<svg viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M4 8 L12 8" stroke="white" stroke-linecap="round" stroke-width="2.5" />
          </svg>`
        )}")`,
        'print-color-adjust': `exact`,
      },
      [`[type='file']`]: {
        cursor: 'pointer',
      },
      [`[type=file]::file-selector-button`]: {
        'background-color': theme('colors.gray.100', colors.gray[100]),
        'border': `${borderWidth['DEFAULT']} solid ${theme('colors.gray.200', colors.gray[200])}`,
        'border-radius': borderRadius['DEFAULT'],
        cursor: 'pointer',
        'padding': `${spacing[2]} ${spacing[3]}`,
        '&:hover': {
          'background-color': theme('colors.gray.200', colors.gray[200]),
        },
      },
      [`.dark [type=file]::file-selector-button`]: {
        '@apply bg-white/5 border-white/5 text-white hover:bg-white/10': {}
      },
      '[type=checkbox]': {
        '@apply w-4 h-4 bg-gray-100 border border-gray-300 rounded-sm focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-white/5 dark:border-white/10': {}
      },
      '[type=radio]': {
        '@apply w-4 h-4 bg-gray-100 border border-gray-300 rounded-full focus:ring-2 focus:ring-blue-300 dark:focus:ring-blue-600 dark:focus:bg-blue-600 dark:bg-white/5 dark:border-white/10': {}
      },
      [['[type=datetime-local]', '[type=month]', '[type=week]', '[type=search]', '[type=date]', '[type=email]', '[type=number]', '[type=password]', '[type=tel]', '[type=text]', '[type=time]', '[type=url]', 'select', 'textarea']]: {
        '@apply bg-gray-50 border border-gray-300 text-gray-900 placeholder:text-gray-400 rounded-md focus:ring-blue-500 focus:border-blue-500 w-full dark:bg-white/5 dark:border-white/10 dark:text-white dark:placeholder:text-gray-500 dark:focus:ring-blue-500 dark:focus:border-blue-500': {}
      },
      'a': {
        '@apply text-blue-600 dark:text-blue-500 underline underline-offset-[.2rem]': {}
      },
    });
    addComponents({
      '.action-item-button': {
        '@apply py-2 px-3 text-sm font-medium no-underline text-gray-900 focus:outline-hidden bg-white rounded-md border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-700 dark:hover:text-white dark:hover:bg-gray-700': {}
      },
      '.index-data-table-toolbar': {
        '@apply flex flex-col lg:flex-row gap-4 mb-4': {}
      },
      '.scopes': {
        '@apply flex flex-wrap gap-1.5': {}
      },
      '.index-button-group': {
        '@apply inline-flex flex-wrap items-stretch rounded-md': {}
      },
      // Prevent double borders when buttons are next to each other
      '.index-button-group > :where(*:not(:first-child))': {
        '@apply -ms-px my-0': {}
      },
      '.index-button': {
        '@apply inline-flex items-center justify-center px-3 py-2 text-sm font-medium no-underline text-gray-900 bg-white border border-gray-200 hover:bg-gray-100 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 first:rounded-s-md last:rounded-e-md dark:bg-gray-900 dark:border-gray-700 dark:text-gray-100 dark:hover:text-gray-200 dark:hover:bg-gray-800 dark:focus:ring-blue-500 dark:focus:text-white': {}
      },
      '.index-button-selected': {
        '@apply bg-gray-100 hover:bg-gray-100 dark:bg-gray-800 dark:hover:bg-gray-800': {}
      },
      '.scopes-count': {
        '@apply inline-flex items-center justify-center rounded-full bg-indigo-100 text-indigo-700 dark:bg-indigo-800/60 dark:text-indigo-400 px-1.5 py-1 text-xs font-normal ms-2 leading-none': {}
      },
      '.paginated-collection': {
        '@apply border border-gray-200 dark:border-gray-800 rounded-md shadow-xs overflow-hidden': {}
      },
      '.paginated-collection-contents': {
        '@apply overflow-x-auto': {}
      },
      '.paginated-collection-pagination': {
        '@apply p-2 lg:p-3 flex flex-col-reverse lg:flex-row gap-4 items-center justify-between border-t border-gray-200 dark:border-gray-800': {}
      },
      '.paginated-collection-footer': {
        '@apply p-3 flex gap-2 items-center justify-between text-sm border-t border-gray-200 dark:border-gray-800': {}
      },
      '.pagination-per-page': {
        '@apply text-sm py-1 pe-7 w-auto w-min': {}
      },
      '.index-as-table': {
        '@apply relative overflow-x-auto': {}
      },
      '.data-table': {
        '@apply w-full text-sm text-gray-800 dark:text-gray-300': {}
      },
      '.data-table :where(thead > tr > th)': {
        '@apply px-3 py-3.5 whitespace-nowrap font-semibold text-start text-xs uppercase border-b border-gray-200 text-gray-700 bg-gray-50 dark:bg-gray-950/50 dark:border-gray-800 dark:text-white': {}
      },
      '.data-table :where(thead > tr > th > a)': {
        '@apply text-inherit no-underline inline-flex items-center gap-2': {}
      },
      '.data-table-sorted-icon': {
        '@apply invisible w-[8px] h-[5px]': {}
      },
      ':where(th[data-sort-direction]) .data-table-sorted-icon': {
        '@apply visible': {}
      },
      ':where(th[data-sort-direction="asc"]) .data-table-sorted-icon': {
        '@apply rotate-180': {}
      },
      '.data-table :where(tbody > tr)': {
        '@apply border-b border-gray-200 dark:border-gray-800 last:border-b-0': {}
      },
      '.data-table :where(td)': {
        '@apply px-3 py-4': {}
      },
      '.data-table-resource-actions': {
        '@apply flex gap-2': {}
      },
      '.filters-form': {
        '@apply text-sm mb-6': {}
      },
      '.filters-form-title': {
        '@apply text-gray-700 dark:text-gray-200 font-bold text-lg mb-4': {}
      },
      '.filters-form :where(.label)': {
        '@apply block mb-1.5 text-sm': {}
      },
      '.filters-form-input-group': {
        '@apply grid grid-cols-2 gap-2': {}
      },
      '.filters-form-field': {
        '@apply mb-4': {}
      },
      '.filters-form-field :where(.choices > label)': {
        '@apply flex gap-2 items-center mb-1': {}
      },
      '.filters-form-buttons': {
        '@apply flex gap-2 items-center': {}
      },
      '.filters-form-submit': {
        '@apply min-w-24 font-bold text-white bg-blue-600 hover:bg-blue-700 focus:ring-4 focus:outline-hidden focus:ring-blue-300 rounded-md px-3 py-2 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800 cursor-pointer': {}
      },
      '.filters-form-clear': {
        '@apply rounded-md px-3 py-2 font-semibold text-gray-700 hover:bg-gray-100 no-underline dark:text-gray-400 dark:hover:bg-inherit dark:hover:text-gray-100 dark:focus:ring-blue-800': {}
      },
      '.active-filters-title': {
        '@apply text-gray-700 dark:text-gray-200 font-bold text-lg mb-4': {}
      },
      '.active-filters-list': {
        '@apply ps-5 list-disc space-y-1 text-gray-700 dark:text-gray-200': {}
      },
      '.batch-actions-dropdown': {
        '@apply relative': {}
      },
      '.batch-actions-dropdown-toggle': {
        '@apply transition-opacity rounded-md inline-flex items-center justify-center gap-2 px-3 py-2 text-sm font-medium text-gray-900 bg-white border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 dark:bg-gray-800 dark:border-gray-700 dark:text-white dark:hover:text-white dark:hover:bg-gray-700 dark:focus:ring-blue-500 dark:focus:text-white disabled:text-gray-400 disabled:border-gray-200/70 dark:disabled:bg-gray-900 dark:disabled:text-gray-700 dark:disabled:border-gray-800 disabled:pointer-events-none': {}
      },
      '.batch-actions-dropdown-arrow': {
        '@apply w-2.5 h-2.5': {}
      },
      '.batch-actions-dropdown-menu': {
        '@apply z-10 hidden min-w-28 bg-white rounded-md shadow-lg ring-1 ring-black/5 focus:outline-hidden dark:bg-gray-800 py-1 text-sm text-gray-700 dark:text-gray-200': {}
      },
      '.batch-actions-dropdown-menu :where(li > a)': {
        '@apply block px-2.5 py-2 no-underline text-gray-700 hover:bg-gray-100 hover:text-gray-900 dark:text-white dark:hover:bg-gray-700 dark:hover:text-white': {}
      },
      '.panel': {
        '@apply mb-6 border border-gray-200 rounded-md shadow-xs dark:border-gray-800': {}
      },
      '.panel-title': {
        '@apply font-bold bg-gray-100 dark:bg-gray-950/50 rounded-t-md p-3': {}
      },
      '.panel-body': {
        '@apply py-5 px-3': {}
      },
      '.attributes-table': {
        '@apply overflow-hidden mb-6 border border-gray-200 rounded-md shadow-xs dark:border-gray-800': {}
      },
      '.attributes-table > :where(table)': {
        '@apply w-full text-sm text-gray-800 dark:text-gray-300': {}
      },
      '.attributes-table :where(tbody > tr)': {
        '@apply border-b border-gray-200 dark:border-gray-800 last:border-b-0 align-baseline': {}
      },
      '.attributes-table :where(tbody > tr > th)': {
        '@apply w-32 sm:w-40 text-start text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-950/50 dark:text-gray-300': {}
      },
      '.attributes-table :where(tbody > tr > th, tbody > tr > td)': {
        '@apply p-3': {}
      },
      '.attributes-table-empty-value': {
        '@apply text-gray-400/50 dark:text-gray-600/50 text-xs uppercase font-semibold': {}
      },
      '.status-tag': {
        '@apply bg-gray-200 text-gray-600 dark:bg-gray-400/20 dark:text-gray-400 inline-flex items-center rounded-full text-sm font-medium px-2.5 py-0.5 whitespace-nowrap': {}
      },
      '.status-tag:where([data-status=yes])': {
        '@apply bg-green-100 text-green-700 dark:bg-green-400/20 dark:text-green-400': {}
      },
      // Forms
      '.formtastic': {
        '@apply text-sm': {}
      },
      '.formtastic :where(.fieldset-title, .has-many-fields-title)': {
        '@apply block w-full mb-3 border-b border-gray-200 dark:border-gray-800 font-bold text-lg': {}
      },
      '.formtastic :where(.label)': {
        '@apply block mb-1.5': {}
      },
      '.formtastic :where(.label abbr)': {
        '@apply ms-1 no-underline': {}
      },
      '.formtastic :where(.input)': {
        '@apply py-3': {}
      },
      '.formtastic :where(.choice)': {
        '@apply mb-1': {}
      },
      '.formtastic :where(.boolean label, .choice label)': {
        '@apply flex gap-2 items-center': {}
      },
      '.formtastic :where(.fragments-group)': {
        '@apply inline-flex flex-wrap gap-1': {}
      },
      '.formtastic :where(.fragment label)': {
        '@apply sr-only': {}
      },
      '.formtastic :where(.inline-hints)': {
        '@apply text-gray-500 dark:text-gray-400 mt-2': {}
      },
      '.formtastic :where(.errors)': {
        '@apply p-4 mb-6 rounded-md space-y-2 bg-red-50 text-red-800 dark:bg-red-500/15 dark:text-red-200': {}
      },
      '.formtastic :where(.errors > li)': {
        '@apply list-disc ms-4': {}
      },
      '.formtastic :where(.inline-errors)': {
        '@apply font-bold mt-2 text-red-600 dark:text-red-400': {}
      },
      '.formtastic :where(.error [type=email], .error [type=number], .error [type=password], .error [type=tel], .error [type=text], .error [type=url], .error select, .error textarea)': {
        '@apply border-red-500/50': {}
      },
      '.formtastic :where(.buttons, .actions)': {
        '@apply mt-3': {}
      },
      '.formtastic :where(.actions > ol)': {
        '@apply flex items-center gap-6': {}
      },
      '.formtastic :where([type=submit], [type=button], button)': {
        '@apply font-bold text-white bg-blue-600 hover:bg-blue-700 focus:ring-4 focus:outline-hidden focus:ring-blue-300 rounded-lg px-4 py-2 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800 cursor-pointer': {}
      },
      '.formtastic :where(.actions .cancel-link)': {
        '@apply font-semibold leading-6 text-gray-900 dark:text-white no-underline': {}
      },
      '.formtastic :where(.has-many-add)': {
        '@apply inline-block py-3': {}
      },
      '.formtastic :where(.has-many-container)': {
        '@apply space-y-8': {}
      },
      '.formtastic :where(.has-many-fields)': {
        '@apply ps-3 border-s-4 border-s-gray-200 dark:border-s-gray-700': {}
      }
    });
  }
)
