$(function() {
  if(!$('.listings-index').length) return;
  
  $('.bxslider').bxSlider({
    onSlideAfter: function(el) {
      console.log($(el).data('description'));
      $(el).closest('.listing-container').find('.description.text').text($(el).data('description'));
    }
  });
});