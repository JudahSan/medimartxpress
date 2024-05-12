/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.html",
    "./app/**/*.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./node_modules/flowbite/**/*.js"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('flowbite/plugin')
  ],
}

