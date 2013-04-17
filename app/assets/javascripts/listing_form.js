$(function() {
  $('#user_listing_attributes_portfolio_photo, #listing_portfolio_photo, #listing_company_logo_photo').bind('change', function(e) { 
    var file = $(this),
        form = $(this).closest("form"),
        logo = file.is('#listing_company_logo_photo'),
        imgEl = logo ? '#company_logo_prev' : '#img_prev';

    $.ajax('/preview_photos', {
      type: 'POST',
      files: $(file, form[0]),
      iframe: true,
      dataType: "json",
      success: function (e) {
        var src = logo ? e.photo.logo.url : e.photo.url;
        $(imgEl).attr("src", src);
      },
      error: function (e) {
        var response = $.parseJSON(e.responseText);
        if(response.errors) {
        } else {
          var src = logo ? response.photo.logo.url : response.photo.url;
          $(imgEl).attr("src", src);
        }
      }    
    });
  });

  var newListingShowDefaultPhoto = $('.new-listing').is(':visible') && !$('#user_listing_attributes_portfolio_photo_cache').val(),
    editListingShowDefaultPhoto = $('.edit-listing').is(':visible') && !$('#listing_portfolio_photo_cache').val() && !$('#img_prev').attr('src');

  if(newListingShowDefaultPhoto || editListingShowDefaultPhoto) {
    $('#img_prev').attr('src', '/assets/small-listing.png');
  }

  $('#user_listing_attributes_portfolio_photo_description, #listing_portfolio_photo_description').on('blur keyup', function() {
    var text = $(this).val() || 'Your image description';
    $('.preview .description').text(text);
  });

  $('#user_listing_attributes_company_name, #listing_company_name').on('blur keyup', function() {
    var text = $(this).val() || 'Your company name';
    $('.preview .company-name').text(text);
  });

  $('#user_listing_attributes_city_id, #listing_city_id').change(function() {
    var text = $('option:selected', this).text() || 'Company location';
    $('.preview .location').text(text);
  });

  $('#user_listing_attributes_specialty_ids, #listing_specialty_ids').change(function(e) {    
    var text = 'Specialties',
        specialties = [];

    $('option:selected', $(this)).each(function() {
      specialties.push($(this).text());
    });
    
    if(specialties.length > 0) {
      text = specialties.join(', ');
    }
    
    $('.preview .specialties').text(text);
  });
});