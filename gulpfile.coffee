gulp = require 'gulp'
sourcemaps = require 'gulp-sourcemaps'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
less = require 'gulp-less'
autoprefix = new (require 'less-plugin-autoprefix')
cleancss = new (require 'less-plugin-clean-css')
browserSync = require 'browser-sync'

paths =
  html: 'app/html/**/*.html'
  coffee: 'src/coffee/**/*.coffee'
  less: 'src/less/**/*.less'
  js: 'app/js'
  css: 'app/css'

gulp.task 'server', ->
  browserSync server:
    baseDir: '.'
    index: 'app/html/index.html'

gulp.task 'reload', ->
  browserSync.reload()

gulp.task 'coffee', ->
  gulp.src(paths.coffee)
    .pipe(sourcemaps.init())
      .pipe(coffee())
      .pipe(uglify())
      .pipe(concat 'app.min.js')
    .pipe(sourcemaps.write())
    .pipe(gulp.dest paths.js)

gulp.task 'less', ->
  gulp.src(paths.less)
    .pipe(sourcemaps.init())
      .pipe(less plugins: [autoprefix, cleancss])
      .pipe(concat 'style.min.css')
    .pipe(sourcemaps.write())
    .pipe(gulp.dest paths.css)

gulp.task 'watch', ->
  gulp.watch paths.html, ['reload']
  gulp.watch paths.coffee, ['coffee', 'reload']
  gulp.watch paths.less, ['less', 'reload']

gulp.task 'default', ['watch', 'coffee', 'less', 'server']
