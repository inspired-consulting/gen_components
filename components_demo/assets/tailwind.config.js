// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require('tailwindcss/plugin')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {},
  },
  // https://daisyui.com/docs/config/
  daisyui: {
    styled: true,
    // https://daisyui.com/docs/themes/
    // https://daisyui.com/theme-generator/
    themes: ["cupcake", "dark", "cmyk"],
    base: true,
    utils: true,
    logs: true,
    rtl: false,
    prefix: "",
  },
  plugins: [
    // if daisyui is not needed, deactivate here
    require('daisyui'),
    require('@tailwindcss/forms'),
    plugin(({ addVariant }) => addVariant('phx-no-feedback', ['&.phx-no-feedback', '.phx-no-feedback &'])),
    plugin(({ addVariant }) => addVariant('phx-click-loading', ['&.phx-click-loading', '.phx-click-loading &'])),
    plugin(({ addVariant }) => addVariant('phx-submit-loading', ['&.phx-submit-loading', '.phx-submit-loading &'])),
    plugin(({ addVariant }) => addVariant('phx-change-loading', ['&.phx-change-loading', '.phx-change-loading &']))
  ]
}
