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
      ['::-webkit-datetime-edit-fields-wrapper']: {
        padding: '0',
      },
      ['::-webkit-date-and-time-value']: {
        'min-height': '1.5em',
      },
      ['select:not([size])']: {
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
        'padding-right': spacing[10],
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
      [[`input[type="range"]::-webkit-slider-thumb`]]: {
        height: spacing[5],
        width: spacing[5],
        background: theme('colors.blue.600', colors.blue[600]),
        'border-radius': borderRadius.full,
        border: 0,
        appearance: 'none',
        '-moz-appearance': 'none',
        '-webkit-appearance': 'none',
        cursor: 'pointer',
      },
      [[`input[type="range"]:disabled::-webkit-slider-thumb`]]: {
        background: theme('colors.gray.400', colors.gray[400]),
      },
      [[`.dark input[type="range"]:disabled::-webkit-slider-thumb`]]: {
        background: theme('colors.gray.500', colors.gray[500]),
      },
      [[`input[type="range"]:focus::-webkit-slider-thumb`]]: {
        outline: '2px solid transparent',
        'outline-offset': '2px',
        '--tw-ring-offset-shadow':
          'var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color)',
        '--tw-ring-shadow':
          'var(--tw-ring-inset) 0 0 0 calc(4px + var(--tw-ring-offset-width)) var(--tw-ring-color)',
        'box-shadow':
          'var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow, 0 0 #0000)',
        '--tw-ring-opacity': 1,
        '--tw-ring-color': 'rgb(164 202 254 / var(--tw-ring-opacity))',
      },
      [[`input[type="range"]::-moz-range-thumb`]]: {
        height: spacing[5],
        width: spacing[5],
        background: theme('colors.blue.600', colors.blue[600]),
        'border-radius': borderRadius.full,
        border: 0,
        appearance: 'none',
        '-moz-appearance': 'none',
        '-webkit-appearance': 'none',
        cursor: 'pointer',
      },
      [[`input[type="range"]:disabled::-moz-range-thumb`]]: {
        background: theme('colors.gray.400', colors.gray[400]),
      },
      [[`.dark input[type="range"]:disabled::-moz-range-thumb`]]: {
        background: theme('colors.gray.500', colors.gray[500]),
      },
      [[`input[type="range"]::-moz-range-progress`]]: {
        background: theme('colors.blue.500', colors.blue[500]),
      },
      [[`input[type="range"]::-ms-fill-lower`]]: {
        background: theme('colors.blue.500', colors.blue[500]),
      },
      [[`input[type="range"].range-sm::-webkit-slider-thumb`]]: {
        height: spacing[4],
        width: spacing[4],
      },
      [[`input[type="range"].range-lg::-webkit-slider-thumb`]]: {
        height: spacing[6],
        width: spacing[6],
      },
      [[`input[type="range"].range-sm::-moz-range-thumb`]]: {
        height: spacing[4],
        width: spacing[4],
      },
      [[`input[type="range"].range-lg::-moz-range-thumb`]]: {
        height: spacing[6],
        width: spacing[6],
      },
      // remove from v2.x+
      ['.toggle-bg:after']: {
        content: '""',
        position: 'absolute',
        top: spacing[0.5],
        left: spacing[0.5],
        background: 'white',
        'border-color': theme('colors.gray.300', colors.gray[300]),
        'border-width': borderWidth['DEFAULT'],
        'border-radius': borderRadius.full,
        height: theme('height.5'),
        width: theme('width.5'),
        'transition-property':
          'background-color,border-color,color,fill,stroke,opacity,box-shadow,transform,filter,backdrop-filter,-webkit-backdrop-filter',
        'transition-duration': '.15s',
        'box-shadow':
          'var(--tw-ring-inset) 0 0 0 calc(0px + var(--tw-ring-offset-width)) var(--tw-ring-color)',
      },
      ['input:checked + .toggle-bg:after']: {
        transform: 'translateX(100%);',
        'border-color': 'white',
      },
      ['input:checked + .toggle-bg']: {
        background: theme('colors.blue.600', colors.gray[600]),
        'border-color': theme('colors.blue.600', colors.gray[600]),
      },
      // remove from v2.x+ END
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
      [`[data-tooltip-style^='light'] + .tooltip > .tooltip-arrow:before`]:
      {
        'border-style': 'solid',
        'border-color': colors.gray[200],
      },
      [`[data-tooltip-style^='light'] + .tooltip[data-popper-placement^='top'] > .tooltip-arrow:before`]:
      {
        'border-bottom-width': '1px',
        'border-right-width': '1px',
      },
      [`[data-tooltip-style^='light'] + .tooltip[data-popper-placement^='right'] > .tooltip-arrow:before`]:
      {
        'border-bottom-width': '1px',
        'border-left-width': '1px',
      },
      [`[data-tooltip-style^='light'] + .tooltip[data-popper-placement^='bottom'] > .tooltip-arrow:before`]:
      {
        'border-top-width': '1px',
        'border-left-width': '1px',
      },
      [`[data-tooltip-style^='light'] + .tooltip[data-popper-placement^='left'] > .tooltip-arrow:before`]:
      {
        'border-top-width': '1px',
        'border-right-width': '1px',
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
      ['[data-popper-arrow]:after']: {
        content: '""',
        visibility: 'visible',
        transform: 'rotate(45deg)',
        position: 'absolute',
        width: '9px',
        height: '9px',
        background: 'inherit',
      },
      [`[role="tooltip"] > [data-popper-arrow]:before`]: {
        'border-style': 'solid',
        'border-color': colors.gray[200],
      },
      [`.dark [role="tooltip"] > [data-popper-arrow]:before`]: {
        'border-style': 'solid',
        'border-color': colors.gray[600],
      },
      [`[role="tooltip"] > [data-popper-arrow]:after`]: {
        'border-style': 'solid',
        'border-color': colors.gray[200],
      },
      [`.dark [role="tooltip"] > [data-popper-arrow]:after`]: {
        'border-style': 'solid',
        'border-color': colors.gray[600],
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='top'] > [data-popper-arrow]:before`]:
      {
        'border-bottom-width': '1px',
        'border-right-width': '1px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='top'] > [data-popper-arrow]:after`]:
      {
        'border-bottom-width': '1px',
        'border-right-width': '1px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='right'] > [data-popper-arrow]:before`]:
      {
        'border-bottom-width': '1px',
        'border-left-width': '1px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='right'] > [data-popper-arrow]:after`]:
      {
        'border-bottom-width': '1px',
        'border-left-width': '1px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='bottom'] > [data-popper-arrow]:before`]:
      {
        'border-top-width': '1px',
        'border-left-width': '1px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='bottom'] > [data-popper-arrow]:after`]:
      {
        'border-top-width': '1px',
        'border-left-width': '1px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='left'] > [data-popper-arrow]:before`]:
      {
        'border-top-width': '1px',
        'border-right-width': '1px',
      },
      [`[data-popover][role="tooltip"][data-popper-placement^='left'] > [data-popper-arrow]:after`]:
      {
        'border-top-width': '1px',
        'border-right-width': '1px',
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
      ['[role="tooltip"].invisible > [data-popper-arrow]:after']: {
        visibility: 'hidden',
      },
      'body': {
        '@apply bg-white dark:bg-gray-900 dark:text-white': {}
      },
      '[type=checkbox]': {
        '@apply w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600': {}
      },
      [['[type=text]', '[type=date]', 'select:not([size])', 'textarea']]: {
        '@apply bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 w-full dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500': {}
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
        '@apply text-xs mt-10 mx-8 pt-9 pb-12 text-gray-500 border-t': {}
      },
      '.page-footer :where(a)': {
        '@apply text-blue-600 underline dark:text-white hover:no-underline': {}
      },
      '.page-title-bar': {
        '@apply bg-gray-50 border-b p-4 mb-8 gap-4 items-center flex justify-between dark:border-gray-700 dark:bg-gray-800': {}
      },
      '.page-title-bar-content': {
        '@apply flex flex-col gap-3 pt-1': {}
      },
      '.page-title-bar-heading': {
        '@apply text-2xl font-semibold': {}
      },
      '.page-title-bar-actions': {
        '@apply flex gap-2 flex-wrap justify-end': {}
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
      '.page-content-container': {
        '@apply px-2.5 lg:px-5 lg:grid lg:gap-4 lg:gap-6 lg:grid-cols-1 lg:grid-flow-col lg:auto-cols-[minmax(0,280px)]': {}
      },
      '.main-content-container': {
        /* @apply shadow-md sm:rounded-lg; */
        /* @apply bg-white border border-gray-200 rounded-lg shadow-sm dark:border-gray-700 dark:bg-gray-800; */
        /* overflow: auto; */
        '': {}
      },
      '.table_tools': {
        '@apply mb-4': {}
      },
      '.paginated_collection': {
        '@apply bg-white border border-gray-200 rounded-lg shadow-sm dark:border-gray-700 dark:bg-gray-800': {}
      },
      '.paginated-collection-footer': {
        '@apply p-4 grid grid-flow-col auto-cols-fr gap-2': {}
      },
      '.pagination_per_page > select': {
        '@apply w-auto w-min': {}
      },
      '.index_as_table': {
        '@apply relative overflow-x-auto': {}
      },
      '.index_table': {
        '@apply w-full text-sm text-left text-gray-800 dark:text-gray-300': {}
      },
      '.index_table :where(thead)': {
        '@apply text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400': {}
      },
      '.index_table :where(thead > tr > th)': {
        '@apply px-5 py-3 whitespace-nowrap': {}
      },
      '.index_table :where(tbody > tr)': {
        '@apply bg-white border-b dark:bg-gray-800 dark:border-gray-700': {}
      },
      '.index_table :where(td)': {
        '@apply px-5 py-3': {}
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
        '@apply bg-red-50 text-red-800 dark:bg-red-800 dark:text-red-300': {}
      },
      '.flash_notice': {
        '@apply bg-green-50 text-green-800 dark:bg-green-800 dark:text-green-400': {}
      },
      '.view_link, .edit_link': {
        '@apply text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2 mr-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800 no-underline': {}
      },
      '.delete_link': {
        '@apply focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-4 py-2 mr-2 mb-2 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-900 no-underline': {}
      },
      '.filter_form :where(label)': {
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
      '.clear_filters_btn': {
        '@apply text-blue-700 hover:bg-gray-100 hover:text-blue-600 font-medium rounded-lg text-sm px-4 py-2.5 text-center dark:border-blue-500 dark:text-blue-500 dark:hover:text-white dark:hover:bg-blue-500 dark:focus:ring-blue-800 transition-colors no-underline': {}
      },
      '.columns': {
        display: 'grid',
        'grid-auto-columns': '1fr',
        'grid-auto-flow': 'column',
        'grid-gap': '1rem',
      },
      '.dropdown_menu': {
        '@apply relative': {}
      },
      '.dropdown_menu_button': {
        '@apply disabled:bg-blue-400 disabled:hover:bg-blue-400 disabled:hover:dark:bg-blue-500 disabled:dark:bg-blue-500 disabled:cursor-not-allowed': {}
      },
      '.dropdown_menu :where(ul)': {
        '@apply z-10 hidden bg-white rounded shadow dark:bg-gray-700 py-1 text-sm text-gray-700 dark:text-gray-200': {}
      },
      '.dropdown_menu :where(ul > li > a)': {
        '@apply block px-2.5 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white': {}
      },
      '.panel': {
        '@apply bg-white border border-gray-200 rounded-lg shadow-sm dark:border-gray-700 dark:bg-gray-800': {}
      },
      '.panel + :where(.panel)': {
        '@apply mt-6': {}
      },
      '.panel > :where(h3)': {
        '@apply font-bold bg-gray-100 rounded-t-lg p-3': {}
      },
      '.panel-body': {
        '@apply py-6 px-4': {}
      },
      // form fieldset.inputs
      '.inputs': {
        '@apply border rounded-lg shadow-sm p-4': {}
      },
      '.attributes_table': {
        '@apply bg-white border border-gray-200 rounded-lg shadow-sm dark:border-gray-700 dark:bg-gray-800': {}
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
