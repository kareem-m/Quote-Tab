const gulp = require("gulp"),
  concat = require("gulp-concat"), // merge files together
  autoprefixer = require("gulp-autoprefixer"), // add prefixes to css code
  sass = require("gulp-sass")(require("sass")), // convert sass to css
  sourcemaps = require("gulp-sourcemaps"), // add sourcemaps
  pug = require("gulp-pug"), // conver pug to html
  livereload = require("gulp-livereload"), // For auto refresh
  uglify = require('gulp-uglify'), // Minify JavaScript
  zip = require('gulp-zip'); // ZIP compress files

// Html Task
gulp.task("html", () => {
  return gulp.src("src/html/*.pug")
    .pipe(pug())
    .pipe(gulp.dest("public"))
    .pipe(livereload());
  });

// Css Task
gulp.task("css", () => {
  return gulp.src("src/css/**/*.*")
    .pipe(sourcemaps.init())
    .pipe(sass({ outputStyle: "compressed" }).on('error', sass.logError))
    .pipe(autoprefixer())
    .pipe(concat("main.css"))
    .pipe(sourcemaps.write("."))
    .pipe(gulp.dest("public/css"))
    .pipe(livereload());
});

// JS Task
gulp.task("js", () => {
  return gulp.src("src/js/*")
    .pipe(concat("main.js"))
    .pipe(uglify())
    .pipe(gulp.dest("public/js"))
    .pipe(livereload());
});

// Zip Task
gulp.task("zip", () => {
  return gulp.src('public/**/*.*')
    .pipe(zip('quote-tap.zip'))
    .pipe(gulp.dest('.'))
    .pipe(gulp.dest('website'))
});

// Watch Task
gulp.task("watch", () => {
  require("./server.js");
  livereload.listen();
  gulp.watch("src/html/**/*", gulp.series("html"));
  gulp.watch("src/css/**/*", gulp.series("css"));
  gulp.watch("src/js/*.js", gulp.series("js"));
  gulp.watch("public/**/*.*", gulp.series("zip"));
});

// Default Task
gulp.task('default', gulp.series('watch'));