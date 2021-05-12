// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("jquery") //for jquery - city populate from states
//for chartkick
require("chartkick")
require("chart.js")
require("chartkick").use(require("highcharts"))
//for datalabels in bar charts
import ChartDataLabels from 'chartjs-plugin-datalabels';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
import "../css/application.css"
import "../css/tailwind.css"
$(document).on('turbolinks:load', function(){
  if ($('#map').length > 0){
    var google_map = $('meta[name=google_maps]').attr("content");
    $.getScript('https://maps.googleapis.com/maps/api/js?key=${google_map}&callback=initMap');
  }
});

