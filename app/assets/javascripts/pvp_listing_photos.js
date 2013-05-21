$(function() {
  
  if(!$('.new-listing form:first, .edit-listing form:first').is('.premium')) return;
  
  $('form.photos textarea').on('blur', function() {
    var textarea = $(this),
        form = $(this).closest("form"),
        errorEl = $('.errors', form).text('').hide();
    
    textarea.attr('disabled', 'disabled');
    
    $.ajax({
      type: 'POST',
      url: form.prop('action') + '/update_description',
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
        errorEl = $('.errors', form).text('').hide();
    
    textarea.attr('disabled', 'disabled');

    $.ajax(form.prop('action'), {
      type: 'POST',
      files: $(file, form[0]),
      iframe: true,
      dataType: "json",
      // for some reason the error handler runs
      error: function (e) {
        console.log(e);
        textarea.removeAttr('disabled');
        var response = $.parseJSON(e.responseText);
        
        if(response.errors) {
          console.log(response.errors.length);
          errorEl.text(response.errors).show();
        } else {
          var now = +new Date;
          var src = response.portfolio_photo.small.url + '?' + now;
          if(imgEl.length) {
            $(imgEl).attr("src", src);
          }
          var action = form.prop('action');
          if(!action.match(/\d+$/)) {
            action = action + '/' + response.id;
            console.log('setting the action to ' + action);
            $(form[0]).prop('action', action);
            console.log($(form[0]).prop('action'));
          }
          
          console.log(response);
        }
      }
    });
  });

});