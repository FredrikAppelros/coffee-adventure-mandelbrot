gulp = require 'gulp'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
rename = require 'gulp-rename'
less = require 'gulp-less'
minifyCSS = require 'gulp-minify-css'
browserSync = require 'browser-sync'

paths =
  html: 'app/html/**/*.html'
  coffee: 'src/coffee/**/*.coffee'
  less: 'src/less/**/*.less'
  js: 'app/js'
  css: 'app/css'
  app: 'app.js'
  entries: [
    'src/coffee/app.coffee'
    'src/coffee/worker.coffee'
  ]

printError = (err) ->
  console.error err
  @emit 'end'

gulp.task 'coffee', ->
  b = browserify(
    entries: paths.entries
    extensions: ['.coffee']
    debug: true
  )

  b.bundle()
    .on('error', printError)
    .pipe(source paths.app)
    .pipe(buffer())
    .pipe(sourcemaps.init loadMaps: true)
      .pipe(uglify())
      .pipe(rename extname: '.min.js')
    .pipe(sourcemaps.write '.')
    .pipe(gulp.dest paths.js)

gulp.task 'less', ->
  gulp.src(paths.less)
    .pipe(sourcemaps.init())
      .pipe(less())
      .on('error', printError)
      .pipe(minifyCSS())
      .pipe(rename extname: '.min.css')
    .pipe(sourcemaps.write())
    .pipe(gulp.dest paths.css)

gulp.task 'server', ['coffee', 'less'], ->
  browserSync server:
    baseDir: 'app'
    index: 'html/index.html'

gulp.task 'reload', ->
  browserSync.reload()

gulp.task 'reload-coffee', ['coffee'], ->
  browserSync.reload()

gulp.task 'reload-less', ['less'], ->
  browserSync.reload()

gulp.task 'watch', ->
  gulp.watch paths.html, ['reload']
  gulp.watch paths.coffee, ['reload-coffee']
  gulp.watch paths.less, ['reload-less']

gulp.task 'default', ['watch', 'server']
