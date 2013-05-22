$(function() {
  var bxslider = $('.bxslider').bxSlider({
    onSlideAfter: function(el) {
      $(el).closest('.listing-container').find('.description.text').text($(el).data('description') || '');
    }
  });
  
  if($('.edit-listing').length) {
    $('body').data('bxslider', bxslider);
  }
});