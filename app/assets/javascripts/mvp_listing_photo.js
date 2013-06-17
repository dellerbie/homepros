$(function() {
  $('#user_listing_attributes_portfolio_photos_attributes_0_portfolio_photo, #listing_portfolio_photos_attributes_0_portfolio_photo, #listing_company_logo_photo').bind('change', function(e) { 
    var file = $(this),
        form = $(this).closest("form"),
        logo = file.is('#listing_company_logo_photo'),
        imgEl = logo ? '.company_logo_prev' : '#img_prev',
        errors = logo ? $('.company-info .logo-errors', form) : $('.sample .errors', form);
        
    errors.hide();
    
    var spinOpts = $.extend($.fn.spin.presets.small, {top: '75px'}),
        spinnerEl = logo ? $('.listing_company_logo_photo') : $('.user_listing_portfolio_photos_portfolio_photo');
        
    spinnerEl.spin(spinOpts);

    $.ajax('/preview_photos', {
      type: 'POST',
      files: $(file, form[0]),
      iframe: true,
      dataType: "json",
      error: function (e) {
        try {
          var response = $.parseJSON(e.responseText);
          if(response.errors) {
            errors.text(response.errors.join(', ')).show();
          } else {
            var src = logo ? response.photo.logo.url : response.photo.url;
            if(imgEl.length) {
              $(imgEl).attr("src", src);
            }
          }
        } catch(e) {
          errors.text('There was an error uploading your photo. Please try again later').show();
        }

        spinnerEl.spin(false);
      }
    });
  });

  $('#user_listing_attributes_portfolio_photos_attributes_0_description, #listing_portfolio_photos_attributes_0_description').on('blur keyup', function() {
    var text = $(this).val() || 'Your image description',
        limit = $('.preview').is('.premium') ? 310 : 60;
        
    if(text.length > limit) {
      text = text.substring(0,limit-3) + '...';
    }
    
    $('.preview .description').text(text);
  });
});