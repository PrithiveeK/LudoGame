module.exports = {
    test: [/\.png$/,/\.jpe?g$/],
    use: [{
      loader: 'url-loader'
    }]
  }
  