$(function() {
  
  if(!$('.new-listing form:first, .edit-listing form:first').is('.premium')) return;
  
  console.log('premium form');
  
  $('form.photos input:file').bind('change', function(e) { 
    var file = $(this),
        form = $(this).closest("form"),
        imgEl = file.parents('.portfolio_photo_wrapper').find('.portfolio_photo_prev');

    $.ajax(form.attr('action'), {
      type: 'POST',
      files: $(file, form[0]),
      data: {
        "_method": "put",
        "authenticity_token": $('input[name="authenticity_token"]').val()
      },
      processData: false,
      iframe: true,
      dataType: "json",
      success: function (e) {
        // var src = logo ? e.photo.logo.url : e.photo.url;
        // if(imgEl.length) {
        //   $(imgEl).attr("src", src);
        // }
        console.log(e);
      },
      error: function (e) {
        console.log(e);
        var response = $.parseJSON(e.responseText);
        if(response.errors) {
        } else {
          // var src = logo ? response.photo.logo.url : response.photo.url;
          // if(imgEl.length) {
          //   $(imgEl).attr("src", src);
          // }
          console.log(response);
        }
      }
    });
  });

});