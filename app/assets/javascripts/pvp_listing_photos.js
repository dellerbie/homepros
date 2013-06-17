$(function() {
  if(!$('.new-listing form:first, .edit-listing form:first').is('.premium')) return;

  var spinOpts = $.extend($.fn.spin.presets.small, {top: '45px'});
  
  function nPhotos() {
    var count = 0;
    $('form.photos').each(function(i, el) {
      if($(el).data('portfolio-photo-id')) {
        count++;
      }
    });
    return count;
  }
  
  function forEachPhotoForm(f) {
    $('form.photos').each(function(i, el) {
      f($(el));
    });
  }
  
  function activateDeleteLinks() {
    var forms = $('form.photos'),
        photoCount = nPhotos();
    
    if(photoCount == 1) {
      $('form.photos a.delete').hide();
    } else {
      forEachPhotoForm(function(el) {
        if($(el).data('portfolio-photo-id')) {
          $(el).find('a.delete').show();
        }
      });
    }
  }
  
  function reloadSliderOpts() {
    return {
      onSlideAfter: function(el) {
        $(el).closest('.listing-container').find('.description.text').text($(el).data('description') || '');
      }
    }
  }
  
  function addPhotoToSlider(form) {
    var slider = $('body').data('bxslider'),
        index = $(form).index(),
        description = truncate($('textarea', form).val() || '', 200),
        src = $('.portfolio_photo_prev', form).data('large-src');
    
    var li = '<li data-description="' + description + '"><img class="portfolio-img" src="' + src + '"></li>';
    slider.append(li);
    slider.reloadSlider(reloadSliderOpts());
  }
  
  function removePhotoFromSlider(form) {
    var slider = $('body').data('bxslider'),
        index = $(form).index();
    
    slider.find('li:not(.bx-clone)').eq(index).remove();
    slider.reloadSlider(reloadSliderOpts());
  }
  
  function updatePhotoInSlider(form) {
    var slider = $('body').data('bxslider'),
        index = $(form).index(),
        description = truncate($('textarea', form).val() || '', 200),
        src = $('.portfolio_photo_prev', form).data('large-src');
    
    var li = slider.find('li:not(.bx-clone)').eq(index);
    li.data('description', description);
    li.find('img').attr('src', src);
    
    slider.reloadSlider(reloadSliderOpts());
  }
  
  function updatePhotoDescriptionInSlider(form) {
    var slider = $('body').data('bxslider'),
        index = $(form).index(),
        description = truncate($('textarea', form).val() || '', 200);
    
    var li = slider.find('li:not(.bx-clone)').eq(index);
    li.data('description', description);
    
    if(index == 0 || slider.getCurrentSlide() == index) {
      $('.listing-container .description.text').text(description);
    } else {
      slider.goToSlide(index);
    }
  }
  
  $('form.photos a.delete').click(function(e) {
    e.preventDefault();
    
    var r = confirm("Are you sure that you want to delete this photo?");
    if(r != true) return;
    
    var form = $(this).closest("form"),
        deleteLnk = $(this),
        listingId = form.data('listing-id'),
        photoId = form.data('portfolio-photo-id'),
        photoCount = nPhotos();
        
    form.find('.portfolio_photo_wrapper').spin(spinOpts);
    
    if(photoId && photoCount > 1) {
      $.ajax({
        type: 'DELETE',
        url: '/listings/' + listingId + '/portfolio_photos/' + photoId,
        dataType: "json",
        success: function (response) {
          removePhotoFromSlider(form);
          form = form.detach();
          form.find("input:file, textarea").val('');
          form.find('.portfolio_photo_prev').attr('src', '/assets/premium-listing.png');
          form.data('portfolio-photo-id', '');
          form.find('.errors').text('').hide();
          form.find('a.delete').hide();
          form.find('textarea').attr('disabled', 'disabled');
          form.find('.sample0').removeClass('sample0');
          $('form.photos:first').find('.sample').addClass('sample0');
          $('.portfolio-photo-forms').append(form);
          $('#img_prev').attr('src', $('form.photos:first .portfolio_photo_prev').data('large-src') || '/assets/premium-listing.png');
          
          activateDeleteLinks();
          form.find('.portfolio_photo_wrapper').spin(false);
        }
      });
    }
  });
  
  $('form.photos textarea').on('blur', function() {
    var textarea = $(this),
        form = $(this).closest("form"),
        errorEl = $('.errors', form).text('').hide();
    
    textarea.attr('disabled', 'disabled');
    
    form.find('.portfolio_photo_wrapper').spin(spinOpts);
    
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
        } else {
          updatePhotoDescriptionInSlider(form);
        }
        form.find('.portfolio_photo_wrapper').spin(false);
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
    file.parents('.portfolio_photo_wrapper').spin(spinOpts);

    $.ajax(url, {
      type: 'POST',
      files: $(file, form[0]),
      iframe: true,
      dataType: "json",
      // for some reason the error handler runs
      error: function (e) {
        textarea.removeAttr('disabled');
        
        try {
          var response = $.parseJSON(e.responseText);

          if(response.errors) {
            errorEl.text(response.errors).show();
          } else {
            var now = +new Date;
            var src = response.portfolio_photo.small.url + '?' + now;
            if(imgEl.length) {
              $(imgEl).attr("src", src).data('large-src', response.portfolio_photo.premium.url + '?' + now);
            }
            if(isCreate) {
              form.data('portfolio-photo-id', response.id);
              var deleteLink = $('a.delete', form);
              deleteLink.attr('href', deleteLink.attr('href') + '/' + response.id);
              activateDeleteLinks();
              addPhotoToSlider(form);
            } else {
              updatePhotoInSlider(form);
            }
          }
        } catch(e) {
          errorEl.text('There was an error uploading your photo. Please try again later').show();
        }

        file.parents('.portfolio_photo_wrapper').spin(false);
      }
    });
  });

});