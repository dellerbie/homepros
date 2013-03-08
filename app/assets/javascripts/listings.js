$(function() {
  
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#img_prev').attr('src', e.target.result);
        $('#img_prev').imagefit();
      };
      
      reader.readAsDataURL(input.files[0]);
    }
  }
  
  $('#user_listing_attributes_portfolio_photo').change(function(e) {
    readURL(e.target);
  });
  
});

