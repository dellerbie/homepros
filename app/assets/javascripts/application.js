// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require html5
//= require jquery.remotipart
//= require jquery.iframe-post-form
//= require jquery.imagefit-0.2
//= require jquery.infinitescroll.min
//= require chosen.jquery.min
//= require jquery.easing.1.3
//= require moment.min
//= require jquery.cookie
//= require jquery.bxslider.min
//= require jquery.placeholder.min
//= require spin.min
//= require jquery.spin
//= require twitter/bootstrap
//= require_tree .

var OCHM = {};

$(function() {  
  function setupInfiniteScroll() {
    $('.listings').infinitescroll({
      navSelector  : "div.pagination",
      nextSelector : "div.pagination a.next_page",
      itemSelector : ".listings li.listing-container",
      loading: {
        msgText: "<em>Loading the next set of listings...</em>",
        finishedMsg: 'No more listings to load.',
        img: '/assets/loader.gif'
      }
    },function(instance, data, url) {
      ga('send', 'event', 'Listings', 'Page', url);
      if($('#homeowners-subscribe-modal').length) {
        OCHM.showHomeownerDialog();
      }
    });
  }
  
  $("body").bind("ajaxSend", function(elm, xhr, s){
    if(s.type == "POST") {
      xhr.setRequestHeader('X-CSRF-Token', jQuery("meta[name=csrf-token]").attr("content"));
    }
  });
  
  setupInfiniteScroll();
  
  $('input, textarea').placeholder();
});

function truncate(text, limit) {
  if(!text) return '';
  
  if(text.length > limit) {
    text = text.substring(0,limit-3) + '...';
  }
  return text;
};


