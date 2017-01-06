# this shell script is to copy the fontfaceobserver
# (standalone, which doesn't include a promise polyfill)
# and combine it with the actual code to observe when
# lato is loaded so that it can be loaded as one script
# in a <script async ...> tag at the top of the page, instead of
# loading it at the bottom and having to wait for all of our other
# js to load.

OUTPUT_FILE=public/javascripts/vendor/lato-fontfaceobserver.js
cp node_modules/fontfaceobserver/fontfaceobserver.standalone.js $OUTPUT_FILE

cat >> $OUTPUT_FILE <<-JAVASCRIPT

new FontFaceObserver('LatoWeb').load().then(function () {
  document.documentElement.classList.add('lato-font-loaded');
}, console.log.bind(console, 'Failed to load Lato font'));

// this file was autogenerated by $0.
// edit that file, not the generated one. Run this again
// if you npm install a new version of fontfaceobserver
// or make any changes.

JAVASCRIPT
