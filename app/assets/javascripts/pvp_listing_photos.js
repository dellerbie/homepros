$(function() {
  
  if(!$('.new-listing form:first, .edit-listing form:first').is('.premium')) return;
  
  $('form.photos textarea').on('blur', function() {
    var textarea = $(this),
        form = $(this).closest("form"),
        errorEl = $('.errors', form).text('').hide();
    
    textarea.attr('disabled', 'disabled');
    
    $.ajax({
      type: 'POST',
      url: '/listings/' + form.data('listing-id') + '/portfolio_photos/' + form.data('portfolio-photo-id') + '/update_description',
      data: {
        "portfolio_photo": {
          "description": textarea.val()
        }
      },
      dataType: "json",
      success: function (response) {
        textarea.removeAttr('disabled');
        if(response.errors) {
          errorEl.text(response.errors).show();
        }
      }
    });
  });
  
  $('form.photos input:file').bind('change', function(e) { 
    var file = $(this),
        form = $(this).closest("form"),
        textarea = $('textarea', form),
        imgEl = file.parents('.portfolio_photo_wrapper').find('.portfolio_photo_prev'),
        errorEl = $('.errors', form).text('').hide(),
        url = '/listings/' + form.data('listing-id') + '/portfolio_photos',
        photoId = form.data('portfolio-photo-id'),
        isCreate = photoId ? false : true;
        
    if(!isCreate) {
      url += '/' + photoId;
    }
    
    textarea.attr('disabled', 'disabled');

    $.ajax(url, {
      type: 'POST',
      files: $(file, form[0]),
      iframe: true,
      dataType: "json",
      // for some reason the error handler runs
      error: function (e) {
        textarea.removeAttr('disabled');
        var response = $.parseJSON(e.responseText);
        console.log(response);
        
        if(response.errors) {
          console.log(response.errors.length);
          errorEl.text(response.errors).show();
        } else {
          var now = +new Date;
          var src = response.portfolio_photo.small.url + '?' + now;
          if(imgEl.length) {
            $(imgEl).attr("src", src);
          }
          if(isCreate) {
            form.data('portfolio-photo-id', response.id);
          }
        }
      }
    });
  });

});