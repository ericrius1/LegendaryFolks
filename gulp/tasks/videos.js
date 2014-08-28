var changed    = require('gulp-changed');
var gulp       = require('gulp');
var imagemin   = require('gulp-imagemin');

gulp.task('images', function() {
  var dest = './build/videos';

  return gulp.src('./src/videos/**')
    .pipe(gulp.dest(dest));
});
