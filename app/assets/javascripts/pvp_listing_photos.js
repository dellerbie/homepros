$(function() {
  
  if(!$('.new-listing form:first, .edit-listing form:first').is('.premium')) return;
  
  console.log('premium form');
  
  $('form.photos input:file').bind('change', function(e) { 
    var file = $(this),
        form = $(this).closest("form"),
        imgEl = file.parents('.portfolio_photo_wrapper').find('.portfolio_photo_prev'),
        errorEl = $('.errors', form).text('').hide();

    $.ajax(form.attr('action'), {
      type: 'POST',
      files: $(file, form[0]),
      iframe: true,
      dataType: "json",
      success: function (e) {
        var src = e.portfolio_photo.small.url;
        if(imgEl.length) {
          $(imgEl).attr("src", src);
        }
        console.log(e);
      },
      error: function (e) {
        console.log(e);
        var response = $.parseJSON(e.responseText);
        if(response.errors) {
          console.log(response.errors.length);
          errorEl.text(response.errors).show();
        } else {
          var src = response.portfolio_photo.small.url + '?' + new Date;
          if(imgEl.length) {
            $(imgEl).attr("src", src);
          }
          var action = form.attr('action');
          if(!action.match(/\d+$/)) {
            console.log('setting the action to ' + form.attr('action', action + '/' + response.id));
            form.attr('action', action + '/' + response.id);
          }
          
          console.log(response);
        }
      }
    });
  });

});