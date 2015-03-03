gulp = require 'gulp'
browserify = require 'browserify'
transform = require 'vinyl-transform'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
rename = require 'gulp-rename'
less = require 'gulp-less'
cleancss = new (require 'less-plugin-clean-css')
browserSync = require 'browser-sync'

paths =
  html: 'app/html/**/*.html'
  coffee: 'src/coffee/**/*.coffee'
  less: 'src/less/**/*.less'
  css: 'app/css'
  entry: [
    'src/coffee/app.coffee'
    'src/coffee/worker.coffee'
  ]

gulp.task 'coffee', ->
  bundle = transform (files) ->
    browserify(
      entries: files
      extensions: ['.coffee']
      debug: true
    ).bundle()

  gulp.src(paths.entry)
    .pipe(bundle)
    .pipe(sourcemaps.init loadMaps: true)
      .pipe(uglify())
      .pipe(rename extname: '.min.js')
    .pipe(sourcemaps.write '.')
    .pipe(gulp.dest 'app/js')

gulp.task 'less', ->
  gulp.src(paths.less)
    .pipe(sourcemaps.init())
      .pipe(less plugins: [cleancss])
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
