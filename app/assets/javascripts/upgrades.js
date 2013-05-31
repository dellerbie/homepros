$(function() {
  if(!$('.upgrades').length) return;
  
  $('.preview .company-name').click(function(e) {
    e.preventDefault();
  });
  
  $('.preview img').closest('a').click(function(e) {
    e.preventDefault();
  });
});