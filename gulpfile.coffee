gulp = require 'gulp'
sourcemaps = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
browserSync = require 'browser-sync'

paths =
  html: 'app/html/*.html'
  css: 'app/css/*.css'
  coffee: 'src/*.coffee'
  js: 'app/js'

gulp.task 'server', ->
  browserSync server:
    baseDir: '.'
    index: 'app/html/index.html'

gulp.task 'reload', ->
  browserSync.reload()

gulp.task 'compile', ->
  gulp.src(paths.coffee)
    .pipe(sourcemaps.init())
      .pipe(coffee())
      .pipe(uglify())
      .pipe(concat 'app.min.js')
    .pipe(sourcemaps.write())
    .pipe(gulp.dest paths.js)

gulp.task 'watch', ->
  gulp.watch paths.html, ['reload']
  gulp.watch paths.css, ['reload']
  gulp.watch paths.coffee, ['compile', 'reload']

gulp.task 'default', ['watch', 'compile', 'server']
