fs = require 'fs'
fs.symlink '../bower_components', 'app/lib', 'dir', (err) ->
  console.error err if err?
