const plugin = require('tailwindcss/plugin')
const defaultTheme = require('tailwindcss/defaultTheme');
const colors = require('tailwindcss/colors');
const [baseFontSize, { lineHeight: baseLineHeight }] = defaultTheme.fontSize.base;
const { spacing, borderWidth, borderRadius } = defaultTheme;

// https://github.com/tailwindlabs/tailwindcss/discussions/9336
// https://github.com/tailwindlabs/tailwindcss/discussions/2049
// https://github.com/tailwindlabs/tailwindcss/discussions/2049#discussioncomment-45546
// console.log('activeadmin tailwind plugin loaded')

const svgToTinyDataUri = (() => {
	// Source: https://github.com/tigt/mini-svg-data-uri
	const reWhitespace = /\s+/g,
		reUrlHexPairs = /%[\dA-F]{2}/g,
		hexDecode = {'%20': ' ', '%3D': '=', '%3A': ':', '%2F': '/'},
		specialHexDecode = match => hexDecode[match] || match.toLowerCase(),
		svgToTinyDataUri = svg => {
			svg = String(svg);
			if(svg.charCodeAt(0) === 0xfeff) svg = svg.slice(1);
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

module.exports = plugin(
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
        '[multiple]',
        'textarea',
        'select',
      ]]: {
        appearance: 'none',
        'background-color': '#fff',
        'border-color': theme('colors.gray.500', colors.gray[500]),
        'border-width': borderWidth['DEFAULT'],
        'border-radius': borderRadius.none,
        'padding-top': spacing[2],
        'padding-right': spacing[3],
        'padding-bottom': spacing[2],
        'padding-left': spacing[3],
        'font-size': baseFontSize,
        'line-height': baseLineHeight,
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
      [['input::placeholder', 'textarea::placeholder']]: {
        color: theme('colors.gray.500', colors.gray[500]),
        opacity: '1',
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
    <path stroke="${theme(
            'colors.gray.500',
            colors.gray[500]
          )}" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/>
    </svg>`
        )}")`,
        'background-position': `right ${spacing[3]} center`,
        'background-repeat': `no-repeat`,
        'background-size': `0.75em 0.75em`,
        'padding-right': spacing[8],
        'print-color-adjust': `exact`,
      },
      ['[multiple]']: {
        'background-image': 'initial',
        'background-position': 'initial',
        'background-repeat': 'unset',
        'background-size': 'initial',
        'padding-right': spacing[3],
        'print-color-adjust': 'unset',
      },
      [[`[type='checkbox']`, `[type='radio']`]]: {
        appearance: 'none',
        padding: '0',
        'print-color-adjust': 'exact',
        display: 'inline-block',
        'vertical-align': 'middle',
        'background-origin': 'border-box',
        'user-select': 'none',
        'flex-shrink': '0',
        height: spacing[4],
        width: spacing[4],
        color: theme('colors.blue.600', colors.blue[600]),
        'background-color': '#fff',
        'border-color': theme('colors.gray.500', colors.gray[500]),
        'border-width': borderWidth['DEFAULT'],
        '--tw-shadow': '0 0 #0000',
      },
      [`[type='checkbox']`]: {
        'border-radius': borderRadius['none'],
      },
      [`[type='radio']`]: {
        'border-radius': '100%',
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
        `[type='radio']:checked`,
        `.dark [type='checkbox']:checked`,
        `.dark [type='checkbox']:indeterminate`,
        `.dark [type='radio']:checked`,
      ]]: {
        'border-color': `transparent`,
        'background-color': `currentColor`,
        'background-size': `0.65rem 0.65rem`,
        'background-position': `center`,
        'background-repeat': `no-repeat`,
      },
      [`[type='checkbox']:checked`]: {
        'background-image': `url("${svgToTinyDataUri(
          `<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 16 12">
            <path stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M1 5.917 5.724 10.5 15 1.5"/>
          </svg>`
        )}")`,
        'background-repeat': `no-repeat`,
        'background-size': `0.65rem 0.65rem`,
        'print-color-adjust': `exact`,
      },
      [`[type='radio']:checked`]: {
        'background-image': `url("${svgToTinyDataUri(
          `<svg viewBox="0 0 16 16" fill="white" xmlns="http://www.w3.org/2000/svg"><circle cx="8" cy="8" r="3"/></svg>`
        )}")`,
        'background-size': `1rem 1rem`,
      },
      [`.dark [type='radio']:checked`]: {
        'background-image': `url("${svgToTinyDataUri(
          `<svg viewBox="0 0 16 16" fill="white" xmlns="http://www.w3.org/2000/svg"><circle cx="8" cy="8" r="3"/></svg>`
        )}")`,
        'background-size': `1rem 1rem`,
      },
      [`[type='checkbox']:indeterminate`]: {
        'background-image': `url("${svgToTinyDataUri(
          `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 16 16"><path stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="4" d="M2 8h12"/></svg>`
        )}")`,
        'background-color': `currentColor`,
        'border-color': `transparent`,
        'background-position': `center`,
        'background-repeat': `no-repeat`,
        'background-size': `.65rem .65rem`,
        'print-color-adjust': `exact`,
      },
      [[
        `[type='checkbox']:indeterminate:hover`,
        `[type='checkbox']:indeterminate:focus`,
      ]]: {
        'border-color': 'transparent',
        'background-color': 'currentColor',
      },
      [`[type='file']`]: {
        background: 'unset',
        'border-color': 'inherit',
        'border-width': '0',
        'border-radius': '0',
        padding: '0',
        'font-size': 'unset',
        'line-height': 'inherit',
      },
      [`[type='file']:focus`]: {
        outline: `1px auto inherit`,
      },
      [[`input[type=file]::file-selector-button`]]: {
        color: 'white',
        background: theme('colors.gray.800', colors.gray[800]),
        border: 0,
        'font-weight': theme('fontWeight.medium'),
        'font-size': theme('fontSize.sm'),
        cursor: 'pointer',
        'padding-top': spacing[2.5],
        'padding-bottom': spacing[2.5],
        'padding-left': spacing[8],
        'padding-right': spacing[4],
        'margin-inline-start': '-1rem',
        'margin-inline-end': '1rem',
        '&:hover': {
          background: theme('colors.gray.700', colors.gray[700]),
        },
      },
      [[`.dark input[type=file]::file-selector-button`]]: {
        color: 'white',
        background: theme('colors.gray.600', colors.gray[600]),
        '&:hover': {
          background: theme('colors.gray.500', colors.gray[500]),
        },
      },
      [['.tooltip-arrow', '.tooltip-arrow:before']]: {
        position: 'absolute',
        width: '8px',
        height: '8px',
        background: 'inherit',
      },
      ['.tooltip-arrow']: {
        visibility: 'hidden',
      },
      ['.tooltip-arrow:before']: {
        content: '""',
        visibility: 'visible',
        transform: 'rotate(45deg)',
      },
      [`.tooltip[data-popper-placement^='top'] > .tooltip-arrow`]: {
        bottom: '-4px',
      },
      [`.tooltip[data-popper-placement^='bottom'] > .tooltip-arrow`]: {
        top: '-4px',
      },
      [`.tooltip[data-popper-placement^='left'] > .tooltip-arrow`]: {
        right: '-4px',
      },
      [`.tooltip[data-popper-placement^='right'] > .tooltip-arrow`]: {
        left: '-4px',
      },
      ['.tooltip.invisible > .tooltip-arrow:before']: {
        visibility: 'hidden',
      },
      [['[data-popper-arrow]', '[data-popper-arrow]:before']]: {
        position: 'absolute',
        width: '8px',
        height: '8px',
        background: 'inherit',
      },
      ['[data-popper-arrow]']: {
        visibility: 'hidden',
      },
      ['[data-popper-arrow]:before']: {
        content: '""',
        visibility: 'visible',
        transform: 'rotate(45deg)',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='top'] > [data-popper-arrow]`]:
      {
        bottom: '-5px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='bottom'] > [data-popper-arrow]`]:
      {
        top: '-5px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='left'] > [data-popper-arrow]`]:
      {
        right: '-5px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='right'] > [data-popper-arrow]`]:
      {
        left: '-5px',
      },
      ['[role="tooltip"].invisible > [data-popper-arrow]:before']: {
        visibility: 'hidden',
      },
      'body': {
        '@apply bg-white dark:bg-gray-950 dark:text-white antialiased': {}
      },
      'a': {
        '@apply text-blue-600 dark:text-blue-500 underline underline-offset-[.2rem]': {}
      },
      '[type=checkbox]': {
        '@apply w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600': {}
      },
      '[type=radio]': {
        '@apply w-4 h-4 border-gray-300 focus:ring-2 focus:ring-blue-300 dark:focus:ring-blue-600 dark:focus:bg-blue-600 dark:bg-gray-700 dark:border-gray-600': {}
      },
      [['[type=date]', '[type=email]', '[type=number]', '[type=password]', '[type=tel]', '[type=text]', '[type=time]', '[type=url]', 'select', 'textarea']]: {
        '@apply bg-gray-50 border border-gray-300 text-gray-900 rounded-lg focus:ring-blue-500 focus:border-blue-500 w-full dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500': {}
      },
    });
    addComponents({
      /* .link-default {
        @apply text-blue-600 underline dark:text-white hover:no-underline;
      } */
      '#header': {
        '@apply border-b border-gray-200 dark:border-gray-700 dark:bg-gray-800 p-2 flex items-center': {}
      },
      '#utility_nav': {
        '@apply flex flex-wrap ms-auto': {}
      },
      '#utility_nav :where(li)': {
        '@apply flex': {}
      },
      '#utility_nav :where(li > a)': {
        '@apply flex ps-3 pe-3': {}
      },
      '.page-footer': {
        '@apply text-xs mt-16 mx-8 pt-9 pb-12 text-gray-500 border-t': {}
      },
      '.page-footer :where(a)': {
        '@apply text-blue-600 underline dark:text-white hover:no-underline': {}
      },
      '.page-title-bar': {
        '@apply bg-gray-50 border-b p-4 mb-8 flex flex-col gap-4 md:flex-row md:items-center justify-between dark:border-gray-700 dark:bg-gray-800': {}
      },
      '.page-title-bar-content': {
        '@apply flex flex-col gap-3 pt-1': {}
      },
      '.page-title-bar-heading': {
        '@apply text-2xl font-semibold': {}
      },
      '.page-title-bar-actions': {
        '@apply flex gap-2 flex-wrap lg:justify-end': {}
      },
      '.breadcrumb-arrow': {
        'background-image': `url("${svgToTinyDataUri(
          `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10"><path stroke="${theme('colors.gray.500', colors.gray[500])}" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 9 4-4-4-4"/></svg>`
        )}")`,
        'background-repeat': 'no-repeat',
        'background-size': '.8em .8em',
        'background-position': 'center center',
        height: '100%',
      },
      '.breadcrumbs': {
        '@apply flex text-xs': {}
      },
      '.breadcrumbs-item': {
        '@apply inline-flex items-center': {}
      },
      ':where(.breadcrumbs-item) + .breadcrumbs-item:before': {
        '@apply px-2 content-[""] breadcrumb-arrow': {}
      },
      '.action-item-button': {
        '@apply py-2.5 px-5 text-sm font-medium no-underline text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700': {}
      },
      '.page-content-container': {
        '@apply px-2.5 lg:px-5 grid grid-cols-1 gap-4 lg:gap-6 lg:grid-flow-col lg:auto-cols-[minmax(0,280px)]': {}
      },
      '.main-content-container': {
        /* @apply shadow-md sm:rounded-lg; */
        /* @apply bg-white border border-gray-200 rounded-lg shadow-sm dark:border-gray-700 dark:bg-gray-800; */
        /* overflow: auto; */
        '': {}
      },
      '.table_tools': {
        '@apply flex flex-col lg:flex-row gap-4 mb-4': {}
      },
      '.scopes': {
        '@apply flex flex-wrap gap-1.5': {}
      },
      '.scopes-group': {
        '@apply inline-flex flex-wrap items-stretch rounded': {}
      },
      // Prevent double borders when buttons are next to each other
      '.scopes-group > :where(*:not(:first-child))': {
        '@apply -ml-px my-0': {}
      },
      '.table_tools_button': {
        '@apply transition-colors inline-flex items-center justify-center px-4 py-2 text-sm font-medium no-underline text-gray-900 bg-white border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 first:rounded-s-lg last:rounded-e-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-blue-500 dark:focus:text-white': {}
      },
      '.table_tools_button.selected': {
        '@apply text-blue-700 dark:text-blue-400': {}
      },
      '.table_tools_button > :where(.count)': {
        '@apply inline-flex items-center justify-center rounded-full bg-gray-200 dark:bg-gray-500 px-2 py-1 text-xs font-medium ms-2 leading-none': {}
      },
      '.paginated_collection': {
        '@apply bg-white border border-gray-200 rounded-lg shadow-sm dark:border-gray-700 dark:bg-gray-800 overflow-hidden': {}
      },
      '.paginated_collection_contents': {
        '@apply overflow-x-auto': {}
      },
      '.paginated-collection-pagination': {
        '@apply p-2 lg:p-4 flex flex-col-reverse lg:flex-row gap-4 items-center justify-between': {}
      },
      '.paginated-collection-footer': {
        '@apply p-3 flex gap-2 items-center justify-between text-sm border-t border-gray-200 dark:border-gray-700': {}
      },
      '.pagination': {
        '@apply inline-flex flex-wrap -space-x-px text-sm gap-1': {}
      },
      '.pagination-link, .pagination-gap': {
        '@apply flex items-center justify-center px-2.5 py-3 h-8 leading-tight text-gray-500 bg-white dark:bg-gray-800 dark:text-gray-400': {}
      },
      '.pagination-gap': {
        '@apply p-0': {}
      },
      '.pagination-link': {
        '@apply hover:bg-gray-100 hover:text-gray-700 dark:hover:bg-gray-700 dark:hover:text-white rounded transition-colors no-underline': {}
      },
      '.pagination-link-active': {
        '@apply text-white bg-blue-500 hover:bg-blue-500 hover:text-white dark:text-white dark:bg-blue-500 dark:hover:bg-blue-500': {}
      },
      '.pagination-icon-arrow': {
        '@apply w-2.5 h-2.5': {}
      },
      '.pagination-per-page': {
        '@apply text-sm py-1 pe-7 w-auto w-min': {}
      },
      '.index_as_table': {
        '@apply relative overflow-x-auto': {}
      },
      '.data-table': {
        '@apply w-full text-sm text-left text-gray-800 dark:text-gray-300': {}
      },
      '.data-table :where(thead > tr > th)': {
        '@apply px-5 py-3 whitespace-nowrap text-xs text-gray-700 uppercase bg-gray-50 border-b dark:bg-gray-800 dark:border-gray-700 dark:text-gray-300': {}
      },
      '.data-table :where(tbody > tr)': {
        '@apply bg-white border-b dark:bg-gray-900 dark:border-gray-700': {}
      },
      '.data-table :where(td)': {
        '@apply px-5 py-3': {}
      },
      '.data-table-default-actions': {
        '@apply flex gap-2': {}
      },
      '.flashes': {
        '@apply px-2.5 lg:px-5 mb-8': {}
      },
      '.flash': {
        '@apply flex items-center gap-3 p-4 mb-2 rounded-lg': {}
      },
      '.flash-icon': {
        '@apply w-5 h-5 shrink-0': {}
      },
      '.flash_alert': {
        '@apply bg-yellow-50 text-yellow-800 dark:bg-yellow-800 dark:text-yellow-300': {}
      },
      '.flash_error': {
        '@apply bg-red-50 text-red-800 dark:bg-red-800 dark:text-red-300': {}
      },
      '.flash_notice': {
        '@apply bg-green-50 text-green-800 dark:bg-green-800 dark:text-green-400': {}
      },
      '.filter_form :where(.label)': {
        '@apply block mb-1.5 text-sm': {}
      },
      '.filter-input-group': {
        //   display: grid;
        //   grid-auto-columns: minmax(0, 1fr);
        //   grid-auto-flow: column;
        //   gap: 0.5rem;
        '@apply grid grid-cols-2 gap-2': {}
      },
      '.filter_form_field': {
        '@apply mb-4': {}
      },
      '.filter_form_field :where(.choices > label)': {
        '@apply flex gap-2 items-center mb-1': {}
      },
      '.clear_filters_btn': {
        '@apply text-blue-700 hover:bg-gray-100 hover:text-blue-600 font-medium rounded-lg text-sm px-4 py-2.5 text-center dark:border-blue-500 dark:text-blue-500 dark:hover:text-white dark:hover:bg-blue-500 dark:focus:ring-blue-800 transition-colors no-underline': {}
      },
      '.dropdown_menu': {
        '@apply relative': {}
      },
      '.dropdown_menu_button': {
        '@apply transition-colors transition-opacity rounded-lg inline-flex items-center justify-center px-4 py-2 text-sm font-medium text-gray-900 bg-white border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-blue-500 dark:focus:text-white disabled:opacity-30 disabled:pointer-events-none': {}
      },
      '.dropdown-menu-button-arrow': {
        '@apply w-2.5 h-2.5 ms-1.5': {}
      },
      '.dropdown_menu :where(ul)': {
        '@apply z-10 hidden min-w-max bg-white rounded shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none dark:bg-gray-700 py-1 text-sm text-gray-700 dark:text-gray-200': {}
      },
      '.dropdown_menu :where(ul > li > a)': {
        '@apply block px-2.5 py-2 no-underline text-gray-700 hover:bg-gray-100 hover:text-gray-900 dark:text-white dark:hover:bg-gray-600 dark:hover:text-white': {}
      },
      '.panel': {
        '@apply bg-white border border-gray-200 rounded-lg shadow-sm dark:border-gray-700 dark:bg-gray-800': {}
      },
      '.panel + :where(.panel)': {
        '@apply mt-6': {}
      },
      '.panel > :where(h3)': {
        '@apply font-bold bg-gray-100 dark:bg-gray-900 rounded-t-lg p-3': {}
      },
      '.panel-body': {
        '@apply py-6 px-4': {}
      },
      '.attributes_table': {
        '@apply overflow-hidden mb-6 bg-white border border-gray-200 rounded-lg shadow-sm dark:border-gray-700 dark:bg-gray-800': {}
      },
      '.attributes_table > :where(table)': {
        '@apply w-full text-sm text-left text-gray-800 dark:text-gray-300': {}
      },
      '.attributes_table :where(tbody > tr)': {
        '@apply bg-white border-b dark:bg-gray-800 dark:border-gray-700': {}
      },
      '.attributes_table :where(tbody > tr > th)': {
        '@apply w-40 text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400': {}
      },
      '.attributes_table :where(tbody > tr > th, tbody > tr > td)': {
        '@apply px-5 py-3': {}
      },
      ':where(.sidebar) .attributes_table :where(tbody > tr > th)': {
        '@apply w-auto w-min': {}
      },
      ':where(.sidebar) .attributes_table :where(tbody > tr > th, tbody > tr > td)': {
        '@apply px-2.5 py-2': {}
      },
      '.status_tag': {
        '@apply bg-gray-200 text-sm font-medium px-2.5 py-0.5 rounded dark:bg-gray-700 dark:text-gray-400': {}
      },
      '.status_tag:where(.yes)': {
        '@apply bg-green-100 text-green-800 text-sm font-medium px-2.5 py-0.5 rounded dark:bg-green-900 dark:text-green-300': {}
      },
      '.tabs-nav': {
        '@apply flex flex-wrap mb-2 text-sm font-medium text-center border-b border-gray-200 dark:border-gray-700': {}
      },
      '.tabs-nav > :where(button)': {
        '@apply inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300': {}
      },
      '.tabs-content': {
        '@apply p-4 mb-6': {}
      },
      '.comments': {
        '@apply max-w-[700px]': {}
      },
      '.comments-header': {
        '@apply font-bold py-3 border-b dark:border-gray-600': {}
      },
      '.comment-form': {
        '@apply mb-12 max-w-[700px]': {}
      },
      '.comments-empty-label': {
        '@apply p-8 text-center': {}
      },
      '.comment-container': {
        '@apply border-b dark:border-gray-600 py-6 max-w-[700px]': {}
      },
      '.comment-header': {
        '@apply flex gap-4 items-end mb-2': {}
      },
      '.comment-author': {
        '@apply font-semibold': {}
      },
      '.comment-date': {
        '@apply text-xs text-gray-400': {}
      },
      '.comment-body': {
        '@apply mb-4 break-keep': {}
      },
      // Forms
      '.formtastic :where(.fieldset-title, .has-many-fields-title)': {
        '@apply block w-full mb-3 border-b font-bold text-lg': {}
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
        '@apply text-gray-500 text-sm mt-2': {}
      },
      '.formtastic :where(.errors)': {
        '@apply p-4 mb-2 rounded-lg bg-red-50 text-red-800 dark:bg-red-800 dark:text-red-300': {}
      },
      '.formtastic :where(.errors > li)': {
        '@apply list-disc ms-4 mb-1': {}
      },
      '.formtastic :where(.inline-errors)': {
        '@apply font-bold mt-2 text-red-600 dark:text-red-300': {}
      },
      '.formtastic :where(.error [type=email], .error [type=number], .error [type=password], .error [type=tel], .error [type=text], .error [type=url], .error textarea)': {
        '@apply border-red-500': {}
      },
      '.formtastic :where(.buttons, .actions)': {
        '@apply mt-3': {}
      },
      '.formtastic :where(.actions > ol:has(li + li))': {
        '@apply flex items-center gap-6': {}
      },
      '.formtastic :where([type=submit], [type=button], button)': {
        '@apply font-bold text-white bg-blue-600 hover:bg-blue-700 focus:ring-4 focus:outline-none focus:ring-blue-300 rounded-lg px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800 cursor-pointer': {}
      },
      '.formtastic :where(.actions .cancel-link)': {
        '@apply font-semibold leading-6 text-gray-900 dark:text-white no-underline': {}
      },
      '.formtastic :where(.has_many_add)': {
        '@apply inline-block py-3': {}
      },
      '.formtastic :where(.has_many_fields)': {
        '@apply my-5 border-s-2 border-s-gray-700 ps-3': {}
      },
      '.devise-body': {
        '@apply bg-gray-50 dark:bg-gray-900': {}
      },
      '.devise-page-container': {
        '@apply flex flex-col items-center justify-center min-h-screen py-4 sm:px-6 sm:py-8 mx-auto': {}
      },
      '.devise-form-container': {
        '@apply p-6 sm:p-8 space-y-4 md:space-y-6 w-full sm:max-w-md bg-white sm:rounded-md shadow dark:border dark:bg-gray-800 dark:border-gray-700': {}
      },
      '.devise-form-title': {
        '@apply text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white': {}
      },
      '.devise-form-button': {
        '@apply w-full': {}
      },
      '.devise-shared-links': {
        '@apply mt-6 text-sm': {}
      },
      '.blank-slate': {
        '@apply relative block w-full rounded-lg border-2 border-dashed border-gray-300 hover:border-gray-400 dark:border-gray-700 dark:hover:border-gray-600 px-6 py-12 text-center': {}
      },
      '.blank-slate-title': {
        '@apply block mb-4 only:mb-0 font-semibold leading-6 text-gray-900 dark:text-gray-200': {}
      },
      // '': {
      //   '': {}
      // },
      // '': {
      //   '': {}
      // },
      // '': {
      //   '': {}
      // },
      // '': {
      //   '': {}
      // },
    });
  }
)
