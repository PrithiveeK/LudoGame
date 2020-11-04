const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
// const webpack = require('webpack')
const dotenv = require('dotenv')
const vue = require('./loaders/vue')

dotenv.config({path: '.env', silent: true})
// environment.plugins.prepend('Environment', new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env))))
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
